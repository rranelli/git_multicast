module GitMassDo
  class RepositoryFetcher
    FETCHERS = [
      GitMassDo::GithubFetcher,
      GitMassDo::BitbucketFetcher
    ]

    def self.get_all_repos_from_user(username)
      multicast(FETCHERS, :get_all_repos_from_user, username).flatten
    end

    def self.get_parent_repo(url)
      fetcher_by_url(url).get_parent_repo(url)
    end

    def self.fetcher_by_url(url)
      fetchers_names = FETCHERS.map do |fetcher|
        match = fetcher.to_s.match(/::(.*)$/)[1]
        match.gsub('Fetcher', '').downcase
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
