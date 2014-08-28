module GitMassDo
  class Puller
    include Process

    attr_reader :dir

    def initialize(dir)
      @dir = dir
    end

    def pull
      dirs = Dir.entries(dir)
        .select { |f| File.directory? f }
        .reject { |f| f =~ /^\./  } # ., .. and .git and the like

      dirs.each do |dir|
        spawn "git -C #{dir} pull -r origin"
      end

      _, statuses = waitall.transpose
      format_result(dirs, statuses)
    end

    def format_result(repositories, statuses)
      repositories.zip(statuses).each do |repo, status|
        puts "Pulled #{repo} successfully" if status && status.success?
        puts "Failed to pull #{repo}" unless status && status.success?
      end
    end
  end
end
