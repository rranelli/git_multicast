module GitMulticast
  class Formatter
    class Standard
      def initialize(start_time = nil)
        @start_time = start_time
      end

      def format(task_result)
        case task_result.exit_status
        when 0
          '[Success]'.green + " #{task_result.name}#{time_report}\n"
        else
          <<EOF
#{'[Error]'.red} #{task_result.name}
#{task_result.result}
EOF
        end
      end

      protected

      attr_reader :start_time

      def time_report
        " | executed in #{Time.now - start_time} seconds" unless start_time.nil?
      end
    end
  end
end
