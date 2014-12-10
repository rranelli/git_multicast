module GitMulticast
  class Formatter
    class Status < Standard
      def format(task_result)
        case task_result.result
        when /\"git add /
          <<EOF
#{'[Changes]'.red} #{task_result.name.red}
#{task_result.result}
EOF
        else
          '[No Changes]'.green + " #{task_result.name}\n"
        end
      end
    end
  end
end
