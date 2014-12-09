module GitMulticast
  class Cloner < Multicaster
    def initialize(username, dir, formatter = OutputFormatter.new(Time.now))
      @username = username
      @dir = dir

      super(formatter)
    end

    protected

    attr_reader :username, :dir

    def tasks
      RepositoryFetcher
        .get_all_repos_from_user(username)
        .map { |repo| Task.new(repo.name, command(repo)) }
    end

    def format(task_result)
      formatter.format(task_result)
    end

    def command(repo)
      if repo.fork
        parent_repo = RepositoryFetcher.get_repo_parent(repo.url)
        "git clone #{repo.ssh_url} #{File.join(dir, repo.name)} && \
git -C \"#{File.join(dir, repo.name)}\" remote add upstream \
#{parent_repo.ssh_url} --fetch"
      else
        "git clone #{repo.ssh_url} #{File.join(dir, repo.name)}"
      end
    end
  end
end
