module GitMulticast
  class Task
    class Runner
      def initialize(tasks, pool_size: 20, pool: Pool.new(pool_size))
        @tasks = tasks
        @pool = pool
        @result_queue = Queue.new
      end

      def run!
        tasks
          .map(&wrap_with_notify)
          .map(&schedule)
          .map(&await)
      end

      protected

      attr_reader :tasks, :result_queue, :pool

      private

      def wrap_with_notify
        -> (task) { -> (*) { result_queue << task.call } }
      end

      def schedule
        -> (task) { pool.schedule([], &task) }
      end

      def await
        -> (_) { result_queue.pop }
      end
    end
  end
end
