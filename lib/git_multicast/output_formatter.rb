module GitMulticast
  class OutputFormatter
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
  end
end
