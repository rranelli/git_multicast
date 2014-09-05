require 'thor'

require_relative '../git_mass_do'

module GitMassDo
  class Cli < Thor
    desc 'git_mass_do pull', 'Git pulls all repositories contained in current directory.'
    def pull
      Puller.new(Dir.pwd).pull
    end

    desc 'git_mass_do clone :username', 'Git pulls all repositories contained in current directory.'
    def clone(username)
      Cloner.new(username, Dir.pwd).clone!
    end
  end
end
