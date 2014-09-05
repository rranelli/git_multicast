module GitMassDo
  class BitbucketAdapter
    def initialize(repo)
      @repo = repo
    end

    def adapt
      make_struct(repo_hash)
    end

    private

    attr_reader :repo

    def repo_hash
      @repo_hash ||= make_repo_hash
    end

    def make_repo_hash
      {
        fork: !repo.parent.nil?,
        ssh_url: repo.links.clone.last.href,
        url: repo.links.self,
        parent: nil,
        name: repo.name
      }
    end

    def make_struct(hash)
      RecursiveOpenStruct.new(hash, recurse_over_arrays: true)
    end
  end
end
