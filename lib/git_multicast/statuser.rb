module GitMulticast
  class Statuser
    def initialize(dir)
      @dir = dir
    end

    def statuses!
      tasks = Dir.entries(dir)
        .select { |f| File.directory? f }
        .reject { |f| f =~ /^\./  } # ., .. and .git and the like
        .map { |dir| Task.new(description(dir), command(dir)) }

      TaskRunner.new(tasks).run!
    end

    protected

    attr_reader :dir

    def command(dir)
      "cd #{dir} && git status"
    end

    def description(dir)
      File.basename(dir)
    end
  end
end
