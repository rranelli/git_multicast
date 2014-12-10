module GitMulticast
  class Task
    class Runner
      def initialize(tasks)
        @tasks = tasks
      end

      def run!
        tasks
          .map(&method(:future))
          .map(&:get)
      end

      protected

      attr_reader :tasks

      def future(task)
        PoorMansFuture.new { task.call }
      end

      class PoorMansFuture
        def initialize
          @thread = Thread.new do
            Thread.current[:output] = yield
          end
        end

        def get
          thread.join
          thread[:output]
        end

        attr_reader :thread
      end
    end
  end
end
