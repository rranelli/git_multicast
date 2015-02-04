require 'thor'

require 'git_multicast'

module GitMulticast
  class Cli < Thor
    class_option :version, type: :boolean

    desc 'git_multicast pull', 'Git pulls all repositories contained in\
 current directory.'
    option :quiet, type: :boolean
    option :verbose, type: :boolean
    def pull
      if formatter
        puts multicaster(:pull).new(Dir.pwd, formatter).execute!
      else
        puts multicaster(:pull).new(Dir.pwd).execute!
      end
    end

    desc 'git_multicast cast :command', 'Casts custom command to all git\
 repositories in current directory.'
    option :quiet, type: :boolean
    option :verbose, type: :boolean
    def cast(command)
      if formatter
        puts multicaster(:generic).new(Dir.pwd, command, formatter).execute!
      else
        puts multicaster(:generic).new(Dir.pwd, command).execute!
      end
    end

    desc 'git_multicast clone :username', 'Git clone all repositories\
 for given username.'
    option :quiet, type: :boolean
    option :verbose, type: :boolean
    def clone(username)
      if formatter
        puts multicaster(:clone).new(username, Dir.pwd, formatter).execute!
      else
        puts multicaster(:clone).new(username, Dir.pwd).execute!
      end
    end

    desc 'git_multicast status', 'Shows status for each repository'
    def status
      puts multicaster(:status).new(Dir.pwd).execute!
    end

    desc 'version', 'Show git_multicast version'
    def version
      puts GitMulticast::VERSION
    end
    default_task :version

    no_tasks do
      def find_version
        version
      end
    end

    private

    def formatter
      return Formatter::Full.new(Time.now) if options[:verbose]
      return Formatter::Quiet.new(Time.now) if options[:quiet]
    end

    def multicaster(method)
      GitMulticast.const_get("Multicaster::#{method.capitalize}")
    end
  end
end
