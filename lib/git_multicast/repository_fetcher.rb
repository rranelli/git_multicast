require_relative 'repository_fetcher/github'
require_relative 'repository_fetcher/bitbucket'

require 'net/http'
require 'json'

module GitMulticast
  class RepositoryFetcher
    FETCHER_ADAPTER_ZIP = [
      [Bitbucket, Adapter::Bitbucket],
      [Github, Adapter::Github]
    ]

    FETCHERS, ADAPTERS = FETCHER_ADAPTER_ZIP.transpose

    def self.get_all_repos_from_user(username)
      FETCHER_ADAPTER_ZIP.map do |fetcher, adapter|
        raw_repos = fetcher.get_all_repos_from_user(username)

        raw_repos.map { |raw_repo| adapter.new(raw_repo).adapt }
      end.flatten
    end

    def self.get_repo(url)
      raw_repo = fetcher_by_url(url).get_repo(url)
      adapter_by_url(url).new(raw_repo).adapt
    end

    def self.get_repo_parent(url)
      get_repo(url).parent
    end

    def self.zip_by_url(url)
      fetchers_names = FETCHERS.map do |fetcher|
        match = fetcher.to_s.match(/Fetcher::(.*)$/)
        match[1].downcase if match
      end

      triples = ([url] * FETCHERS.size).zip(fetchers_names, FETCHER_ADAPTER_ZIP)
      triples.find { |u, name, _| u.match name }.last
    end

    def self.fetcher_by_url(url)
      zip_by_url(url).first
    end

    def self.adapter_by_url(url)
      zip_by_url(url).last
    end

    def self.make_struct(hash)
      RecursiveOpenStruct.new(hash, recurse_over_arrays: true)
    end
  end
end
