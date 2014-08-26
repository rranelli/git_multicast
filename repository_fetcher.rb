require 'recursive-open-struct'
require 'json'

class RepositoryFetcher
  def self.get_all_repos_from_user(username)
    get_response(username).map { |hash| make_struct(hash) }
  end

  def self.get_repo(url)
    response = Net::HTTP.get_response(URI(url))
    make_struct(JSON.parse(response.body))
  end

  def self.get_response(username)
    uri_str = "https://api.github.com/users/#{username}/repos"

    response = Net::HTTP.get_response(URI(uri_str))
    puts response
    JSON.parse(response.body)
  end

  def self.make_struct(hash)
    RecursiveOpenStruct.new(hash, recurse_over_arrays: true)
  end
end
