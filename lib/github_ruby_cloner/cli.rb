require 'thor'

require_relative '../github-ruby-cloner'

module GithubRubyCloner
  class CLI < Thor
    desc 'pulls your repositories'

    def pull
      Puller.pull
    end

    def clone
      Cloner.clone
    end
  end
end
