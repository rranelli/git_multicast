module GitMulticast
  class TaskRunner
    include Process

    def initialize(actions)
      @actions = actions
      @formatter = OutputFormatter.new(Time.now)
    end

    def run!
      actions
        .map(&method(:future))
        .map(&:get)
        .inject("", &:+)
    end

    protected

    attr_reader :actions, :formatter

    def future(action)
      PoorMansFuture.new { formatter.single_format(action.call) }
    end

    class PoorMansFuture
      def initialize(&block)
        @thread = Thread.new do
          Thread.current[:output] = block.call
        end
      end

      def get
        thread.join and thread[:output]
      end

      attr_reader :thread
    end
  end
end
