require 'thor'

require 'git_multicast'

module GitMulticast
  class Cli < Thor
    desc 'git_multicast pull', 'Git pulls all repositories contained in\
 current directory.'
    def pull(quiet = nil)
      puts Multicaster::Pull.new(Dir.pwd, formatter(quiet)).execute!
    end

    desc 'git_multicast clone :username', 'Git pulls all repositories\
 contained in current directory.'
    def clone(username, quiet = nil)
      puts Multicaster::Clone.new(username, Dir.pwd, formatter(quiet)).execute!
    end

    desc 'git_multicast status', 'Shows status for each repository'
    def status(quiet = nil)
      puts Multicaster::Status.new(Dir.pwd, formatter(quiet)).execute!
    end

    desc 'git_multicast version', 'Shows currently installed version'
    def version
      puts GitMulticast::VERSION
    end

    private

    def multicaster(method)
      const_get("Multicaster::#{method.capitalize}")
    end

    def formatter(quiet = nil)
      if quiet
        QuietFormatter.new(Time.now)
      else
        OutputFormatter.new(Time.now)
      end
    end
  end
end
