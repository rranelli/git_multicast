require 'net/http'
require 'json'

module GitMassDo
  class Cloner
    include Process

    def initialize(username)
      @username = username
    end

    def clone_em_all!(repos)
      repos.map do |repo|
        spawn(make_command(repo))
      end
      waitall.map { |_, status| status }
    end

    private

    attr_reader :username

    def clone!
      start_time = Time.now
      repos = RepositoryFetcher.get_all_repos_from_user(username)
      statuses = clone_em_all!(repos)

      OutputFormatter.format(repos, statuses, start_time)
    end

    def make_command(repo)
      if repo.fork
        parent_repo = RepositoryFetcher.get_repo(repo.url).parent
        "git clone #{repo.ssh_url} && \
git -C #{repo.name} remote add upstream #{parent_repo.ssh_url} --fetch"
      else
        "git clone #{repo.ssh_url}"
      end
    end
  end
end
