module GitMulticast
  class Multicaster
    class Clone < Multicaster
      def initialize(username, dir,
          formatter = Formatter::Standard.new(Time.now)
      )
        @username = username
        @dir = dir

        super(formatter)
      end

      protected

      attr_reader :username, :dir

      private

      def tasks
        RepositoryFetcher
          .get_all_repos_from_user(username)
          .map { |repo| Task.new(description(repo), command(repo)) }
      end

      def description(repo)
        "Cloning #{repo.name}..."
      end

      def command(repo)
        if repo.fork
          clone_repo_with_parent(repo)
        else
          clone(repo)
        end
      end

      def clone_repo_with_parent(repo)
        parent_repo = RepositoryFetcher.get_repo_parent(repo.url)
        "git clone #{repo.ssh_url} #{File.join(dir, repo.name)} && \
git -C \"#{File.join(dir, repo.name)}\" remote add upstream \
#{parent_repo.ssh_url} --fetch"
      end

      def clone(repo)
        "git clone #{repo.ssh_url} #{File.join(dir, repo.name)}"
      end
    end
  end
end
