#!/usr/bin/env ruby
require 'net/http'
require 'json'

class Cloner
  include Process

  def clone_em_all!(repos)
    repos.map do |repo|
      spawn(make_command(repo))
      command
    end
    waitall.map { |_, status| status }
  end

  def make_command(repo)
    if repo.fork
      parent_repo = RepositoryFetcher.get_repo(repo.url).parent
      "git clone #{repo.ssh_url} &&
       cd #{repo.name} &&
       git remote add upstream #{parent_repo.ssh_url} --fetch"
    else
      "git clone #{repo.ssh_url}"
    end
  end
end

# main logic
start_time = Time.now
repos = RepositoryFetcher.get_all_repos_from_user('rranelli')
statuses = clone_em_all!(repos)

urls = repos.map(&:url)
OutputFormatter.format(urls, statuses, start_time)
