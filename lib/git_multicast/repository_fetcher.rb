module GitMulticast
  class RepositoryFetcher
    FETCHERS = [
      GitMulticast::GithubFetcher,
      GitMulticast::BitbucketFetcher
    ]

    def self.get_all_repos_from_user(username)
      multicast(FETCHERS, :get_all_repos_from_user, username).flatten
    end

    def self.get_repo_parent(url)
      fetcher_by_url(url).get_repo_parent(url)
    end

    def self.fetcher_by_url(url)
      fetchers_names = FETCHERS.map do |fetcher|
        match = fetcher.to_s.match(/::(.*)$/)
        match[1].gsub('Fetcher', '').downcase if match
      end

      triples = ([url] * FETCHERS.count).zip(fetchers_names, FETCHERS)

      triples.select { |u, name, _| u.match name }.first.last
    end

    def self.multicast(list, method, *args)
      list.map do |e|
        e.send(method, *args)
      end
    end
  end
end
