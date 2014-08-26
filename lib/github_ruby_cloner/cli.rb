require 'thor'

require_relative '../github-ruby-cloner'

module GithubRubyCloner
  class Cli < Thor
    desc 'github_ruby_cloner pull', 'Git pulls all repositories contained in current directory.'
    def pull
      Puller.pull
    end

    desc 'github_ruby_cloner clone :username', 'Git pulls all repositories contained in current directory.'
    def clone(username)
      Cloner.new(username).clone!
    end
  end
end
