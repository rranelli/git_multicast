require 'thread'

module GitMulticast
  class Task
    class Pool
      def self.pool
        @pool ||= new(20)
      end

      def initialize(size)
        @size = size
        @queue = Queue.new
        @pool = (1..size).map { Thread.new(&job_loop) }
      end

      def schedule(*args, &blk)
        queue << [blk, args]
      end

      def shutdown
        size.times { schedule { throw :exit } }
        pool.map(&:join)
      end

      protected

      attr_reader :size, :queue, :pool

      private

      def job_loop
        -> { catch(:exit) { loop(&run_job) } }
      end

      def run_job
        lambda do
          job, args = queue.pop
          job.call(*args)
        end
      end
    end
  end
end
