module GitMulticast
  class OutputFormatter
    def initialize(start_time = nil)
      @start_time = start_time
    end

    # TODO: THIS WILL DIEEEEEEEEEEEEEEEEE
    def self.format(output_status_zip, start_time = nil)
      # get successes and failures
      success_pairs = output_status_zip.select { |_, status| status.success? }
      failure_pairs = output_status_zip.reject { |_, status| status.success? }

      success_pairs.each do |output, _|
        puts(
          "#{output} \nsuccess.\n" \
          '=============================================='
        )
      end
      failure_pairs.each { |output, _|  puts "#{output}\nFAILURE!!" }

      puts '#############################################'
      puts "Finished in #{Time.now - start_time} seconds." if start_time
    end

    def single_format(task_result)
      case task_result.exit_status
      when 0
        "[Success] #{task_result.name} #{time_report}"
      else
        <<EOF
#{'-' * 25}
[Error] #{task_result.name}
#{task_result.result}
#{'-' * 25}

EOF
      end
    end

    protected

    attr_reader :start_time

    def time_report
      "in #{Time.now - start_time} seconds" unless start_time.nil?
    end
  end
end
