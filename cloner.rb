#!/usr/bin/env ruby
require_relative 'output_formatter'
require_relative 'repository_fetcher'

require 'net/http'
require 'json'

include Process

def clone_em_all!(repos)
  repos.map do |repo|
    if repo.fork
      parent_repo = RepositoryFetcher.get_repo(repo.url).parent
      command = "git clone #{repo.ssh_url} &&
                 cd #{repo.name} &&
                 git remote add upstream #{parent_repo.ssh_url} --fetch"
    else
      command = "git clone #{repo.ssh_url}"
    end

    spawn(command)
    command
  end
  waitall.map { |_, status| status }
end

# main logic
start_time = Time.now
repos = RepositoryFetcher.get_all_repos_from_user('rranelli')
statuses = clone_em_all!(repos)

urls = repos.map(&:url)
OutputFormatter.format(urls, statuses, start_time)
