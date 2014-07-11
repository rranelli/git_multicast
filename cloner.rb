#!/usr/bin/env ruby
require_relative 'output_formatter'
require_relative 'repository_fetcher'

require 'net/http'
require 'json'

include Process

def clone_em_all!(urls)
  urls.map do |ssh_url|
    spawn("git clone #{ssh_url}")
  end

  waitall.map { |_, status| status }
end

# main logic
start_time = Time.now

urls = RepositoryFetcher.get_all_repos_from_user('rranelli', 'ssh')

statuses = clone_em_all!(urls)

OutputFormatter.format(urls, statuses, start_time)
