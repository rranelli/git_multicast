require 'recursive-open-struct'
require 'json'

module GitMulticast
  class RepositoryFetcher
    class Github < RepositoryFetcher
      REPOS_URI = 'https://api.github.com/users/%{username}/repos'

      def self.get_all_repos_from_user(username, uri_str = make_uri(username))
        uri = URI(uri_str)

        response = Net::HTTP.get_response(uri)
        repos = JSON.parse(response.body)

        built_repos = repos.map { |hash| make_struct(hash) }

        if response['Link'] =~ /rel=\"next\"/
          next_uri = response['Link'].match(/<(.*)>; rel=\"next\"/)[1]

          built_repos + get_all_repos_from_user(username, next_uri)
        else
          built_repos
        end
      end

      def self.get_repo(url)
        response = Net::HTTP.get_response(URI(url + access_token))
        make_struct(JSON.parse(response.body))
      end

      def self.make_uri(username)
        (REPOS_URI % { username: username }) + access_token
      end

      def self.access_token
        (ENV['GITHUB_ACCESS_TOKEN'] && "?access_token=#{ENV['GITHUB_ACCESS_TOKEN']}").to_s
      end
    end
  end
end
