require 'recursive-open-struct'
require 'json'

module GitMulticast
  class RepositoryFetcher
    class Github < RepositoryFetcher
      REPOS_URI = 'https://api.github.com/users/%{username}/repos'

      def self.get_all_repos_from_user(username)
        uri_str = REPOS_URI % { username: username }
        uri = URI(uri_str)

        response = Net::HTTP.get_response(uri)
        repos = JSON.parse(response.body)

        repos.map { |hash| make_struct(hash) }
      end

      def self.get_repo(url)
        response = Net::HTTP.get_response(URI(url))
        make_struct(JSON.parse(response.body))
      end
    end
  end
end
