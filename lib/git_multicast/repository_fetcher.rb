require_relative 'repository_fetcher/github'
require_relative 'repository_fetcher/bitbucket'

module GitMulticast
  class RepositoryFetcher
    FETCHERS = [
      Bitbucket,
      Github
    ]

    def self.get_all_repos_from_user(username)
      multicast(FETCHERS, :get_all_repos_from_user, username).flatten
    end

    def self.get_repo(url)
      response = Net::HTTP.get_response(URI(url))
      make_struct(JSON.parse(response.body))
    end

    def self.get_repo_parent(url)
      fetcher_by_url(url).get_repo(url).parent
    end

    def self.fetcher_by_url(url)
      fetchers_names = FETCHERS.map do |fetcher|
        match = fetcher.to_s.match(/::(.*)$/)
        match[1].gsub('Fetcher', '').downcase if match
      end

      triples = ([url] * FETCHERS.count).zip(fetchers_names, FETCHERS)
require 'pry'; binding.pry

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
