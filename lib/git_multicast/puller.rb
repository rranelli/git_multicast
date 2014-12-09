module GitMulticast
  class Puller < Multicaster
    def initialize(dir, formatter = OutputFormatter.new(Time.now))
      @dir = dir

      super(formatter)
    end

    protected

    attr_reader :dir

    def tasks
      Dir.entries(dir)
        .select { |f| File.directory? f }
        .reject { |f| f =~ /^\./  } # ., .. and .git and the like
        .map { |dir| Task.new(description(dir), command(dir)) }
    end

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
