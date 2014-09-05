module GitMassDo
  class BitbucketFetcher
    REPOS_URI = 'https://bitbucket.org/api/2.0/repositories/%{username}'

    def self.get_all_repos_from_user(username)
      uri_str = REPOS_URI % { username: username }
      uri = URI(uri_str)

      response = Net::HTTP.get_response(uri)
      response_json = JSON.parse(response.body)

      # Damn...
      response_json['values'].each do |node|
        node['links']['_clone'] = node['links']['clone']
      end

      bb_repos = response_json['values'].map { |hash| make_struct(hash) }
      bb_repos.map { |bb_repo| BitbucketAdapter.new(bb_repo).adapt }
    end

    def self.get_repo_parent(url)
      bb_repo = get_repo(url).parent
      BitbucketAdapter.new(bb_repo).adapt
    end

    def self.get_repo(url)
      response = Net::HTTP.get_response(URI(url))
      bb_repo = make_struct(JSON.parse(response.body))
      BitbucketAdapter.new(bb_repo).adapt
    end

    def self.make_struct(hash)
      RecursiveOpenStruct.new(hash, recurse_over_arrays: true)
    end
  end
end
