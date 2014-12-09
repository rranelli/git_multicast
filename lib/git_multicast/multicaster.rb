module GitMulticast
  class Multicaster
    def initialize(formatter)
      @formatter = formatter
    end

    def execute!
      TaskRunner
        .new(tasks)
        .run!
        .map(&method(:format))
        .reduce('', &:+)
    end

    def tasks
      fail NotImplementedError
    end

    protected

    attr_reader :formatter
  end
end
