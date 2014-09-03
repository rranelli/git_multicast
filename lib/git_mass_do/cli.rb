require 'thor'

require_relative '../git_mass_do'

module GitMassDo
  class Cli < Thor
    desc 'git_mass_do pull', 'Git pulls all repositories contained in current directory.'
    def pull(dir = Dir.pwd)
      Puller.new(dir).pull
    end

    desc 'git_mass_do clone :username', 'Git pulls all repositories contained in current directory.'
    def clone(username, dir = Dir.pwd)
      Cloner.new(username, dir).clone!
    end
  end
end
