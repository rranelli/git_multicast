require_relative 'repository_fetcher/github'
require_relative 'repository_fetcher/bitbucket'

module GitMulticast
  class RepositoryFetcher
    FETCHERS = [
      Bitbucket,
      Github
    ]

    ADAPTERS = [
      Adapters::Bitbucket,
      Adapters::Github
    ]

    def self.get_all_repos_from_user(username)
      multicast(FETCHERS, :get_all_repos_from_user, username)
        .flatten
#TODO: adapt the results
    end

    def self.get_repo(url)
      raw_repo = fetcher_by_url(url).get_repo(url)
      adapter_by_url(url).new(raw_repo).adapt
    end

    def self.get_repo_parent(url)
      raw_repo = fetcher_by_url(url).get_repo(url).parent
      adapter_by_url(url).new(raw_repo).adapt
    end

    def self.fetcher_by_url(url)
      fetchers_names = FETCHERS.map do |fetcher|
        match = fetcher.to_s.match(/Fetcher::(.*)$/)
        match[1].downcase if match
      end

      triples = ([url] * FETCHERS.count).zip(fetchers_names, FETCHERS)
      triples.select { |u, name, _| u.match name }.first.last
    end

    def self.adapter_by_url(url)
      adapters_names = ADAPTERS.map do |adapter|
        match = adapter.to_s.match(/Adapters::(.*)$/)
        match[1].downcase if match
      end

      triples = ([url] * ADAPTERS.count).zip(adapters_names, ADAPTERS)
      triples.select { |u, name, _| u.match name }.first.last
    end

    def self.make_struct(hash)
      RecursiveOpenStruct.new(hash, recurse_over_arrays: true)
    end

    def self.multicast(list, method, *args)
      list.map do |e|
        e.send(method, *args)
      end
    end
  end
end
