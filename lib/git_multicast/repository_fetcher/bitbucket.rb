module GitMulticast
  class RepositoryFetcher
    class Bitbucket < RepositoryFetcher
      REPOS_URI = 'https://bitbucket.org/api/2.0/repositories/%{username}'

      def self.get_all_repos_from_user(username)
        uri_str = REPOS_URI % { username: username }
        uri = URI(uri_str)

        response = Net::HTTP.get_response(uri)
        response_json = JSON.parse(response.body)

        # Damn...
        response_json['values'].each do |repo|
          repo['links']['_clone'] = repo['links']['clone']
        end

        response_json['values'].map { |hash| make_struct(hash) }
      end

      def self.get_repo(url)
        response = Net::HTTP.get_response(URI(url))
        response_json = JSON.parse(response.body)
        response_json['links']['_clone'] = response_json['links']['clone']

        make_struct(response_json)
      end

      def self.make_struct(hash)
        RecursiveOpenStruct.new(hash, recurse_over_arrays: true)
      end
    end
  end
end
