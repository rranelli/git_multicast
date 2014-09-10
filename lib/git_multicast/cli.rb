require 'thor'

require_relative '../git_multicast'

module GitMulticast
  class Cli < Thor
    desc 'git_multicast pull', 'Git pulls all repositories contained in\
 current directory.'
    def pull
      Puller.new(Dir.pwd).pull
    end

    desc 'git_multicast clone :username', 'Git pulls all repositories\
 contained in current directory.'
    def clone(username)
      Cloner.new(username, Dir.pwd).clone!
    end
  end
end
