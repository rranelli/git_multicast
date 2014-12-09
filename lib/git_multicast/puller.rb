module GitMulticast
  class Puller
    def initialize(dir, formatter = OutputFormatter.new(Time.now))
      @dir = dir
      @formatter = formatter
    end

    def pull!
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
      "git -C #{dir} pull -r origin"
    end

    def description(dir)
      File.basename(dir)
    end
  end
end
