require 'net/http'
require 'json'

module GitMulticast
  class Cloner
    include Process

    def initialize(username, dir)
      @username = username
      @dir = dir
    end

    def clone!
      start_time = Time.now
      repos = RepositoryFetcher.get_all_repos_from_user(username)
      statuses = clone_em_all!(repos)

      OutputFormatter.format(repos, statuses, start_time)
    end

    protected

    attr_reader :username, :dir

    def clone_em_all!(repos)
      repos.map do |repo|
        spawn(make_command(repo))
      end
      waitall.map { |_, status| status }
    end

    def make_command(repo)
      if repo.fork
        parent_repo = RepositoryFetcher.get_repo_parent(repo.url)
        "git clone #{repo.ssh_url} #{ File.join(dir, repo.name) } && \
git -C \"#{ File.join(dir, repo.name) }\" remote add upstream \
#{parent_repo.ssh_url} --fetch"
      else
        "git clone #{repo.ssh_url} #{ File.join(dir, repo.name) }"
      end
    end
  end
end
