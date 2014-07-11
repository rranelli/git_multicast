#!/usr/bin/env ruby
require 'net/http'
require 'json'

include Process

def get_all_repos_from_user(username, protocol = 'ssh')
  repos = get_response(username)

  get_urls(repos, protocol)
end

def get_urls(repos, protocol)
  case protocol
  when 'ssh'
    repos.map { |entry| entry['ssh_url'] }
  when 'http'
    repos.map { |entry| entry['clone_url'] }
  end
end

def get_response(username)
  uri_str = "https://api.github.com/users/#{username}/repos"

  response = Net::HTTP.get_response(URI(uri_str))
  JSON.parse(response.body)
end

def clone_em_all!(ssh_urls)
  ssh_urls.map do |ssh_url|
    spawn("git clone #{ssh_url}")
  end

  waitall.map { |_, status| status }
end

def format_output(urls, statuses, start_time = nil)
  url_status_pairs = urls.zip(statuses)

  # get successes and failures
  success_pairs = url_status_pairs.select { |_, status| status.success? }
  failure_pairs = url_status_pairs.reject { |_, status| status.success? }

  success_pairs.each { |ssh_url, _| puts "#{ssh_url} cloned successfully." }
  failure_pairs.each { |ssh_url, _|  puts "failure to clone #{ssh_url}." }

  puts '=========================================='
  puts "Finished in #{Time.now - start_time} seconds." if start_time
end

# main logic
start_time = Time.now

urls = get_all_repos_from_user('rranelli', 'ssh')
statuses = clone_em_all!(urls)
format_output(urls, statuses, start_time)
