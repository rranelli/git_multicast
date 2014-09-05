module GitMassDo
  class RepositoryFetcher
    FETCHERS = [
      GitMassDo::GithubFetcher,
      GitMassDo::BitbucketFetcher
    ]

    def self.get_all_repos_from_user(username)
      multicast(FETCHERS, :get_all_repos_from_user, username).flatten
    end

    def self.multicast(list, method, *args)
      list.map do |e|
        e.send(method, *args)
      end
    end
  end
end
