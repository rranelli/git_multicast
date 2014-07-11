class RepositoryFetcher
  def self.get_all_repos_from_user(username, protocol = 'ssh')
    repos = get_response(username)

    get_urls(repos, protocol)
  end

  def self.get_urls(repos, protocol)
    case protocol
    when 'ssh'
      repos.map { |entry| entry['ssh_url'] }
    when 'http'
      repos.map { |entry| entry['clone_url'] }
    end
  end

  def self.get_response(username)
    uri_str = "https://api.github.com/users/#{username}/repos"

    response = Net::HTTP.get_response(URI(uri_str))
    JSON.parse(response.body)
  end
end
