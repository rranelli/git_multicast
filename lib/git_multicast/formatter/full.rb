module GitMulticast
  class Formatter
    class Full < Standard
      def format(task_result)
        case task_result.exit_status
        when 0
          <<EOF
#{'[Success]'.green} #{task_result.name}
#{task_result.result}
#{time_report}\n
EOF
        else
          super(task_result)
        end
      end
    end
  end
end
