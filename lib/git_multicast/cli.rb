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

    desc 'git_multicast status', 'Shows status for each repository'
    def status
      Statuser.new(Dir.pwd).get_statuses
    end

    desc 'git_multicast version', 'Shows currently installed version'
    def version
      puts GitMulticast::VERSION
    end
  end
end
