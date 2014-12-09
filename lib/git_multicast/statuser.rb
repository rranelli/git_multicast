module GitMulticast
  class Statuser
    def initialize(dir, formatter = OutputFormatter.new(Time.now))
      @dir = dir
      @formatter = formatter
    end

    def statuses!(quiet = nil)
      tasks = Dir.entries(dir)
        .select { |f| File.directory? f }
        .reject { |f| f =~ /^\./  } # ., .. and .git and the like
        .map { |dir| Task.new(description(dir), command(dir)) }

      TaskRunner
        .new(tasks)
        .run!
        .map(&method(:format))
        .reduce('', &:+)
    end

    protected

    attr_reader :dir, :formatter

    def format(task_result)
      formatter.format(task_result)
    end

    def command(dir)
      "cd #{dir} && git status"
    end

    def description(dir)
      File.basename(dir)
    end
  end
end
