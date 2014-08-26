class OutputFormatter
  def self.format(urls, statuses, start_time = nil)
    url_status_pairs = urls.zip(statuses)

    # get successes and failures
    success_pairs = url_status_pairs.select { |_, status| status.success? }
    failure_pairs = url_status_pairs.reject { |_, status| status.success? }

    success_pairs.each { |ssh_url, _| puts "#{ssh_url} cloned successfully." }
    failure_pairs.each { |ssh_url, _|  puts "failure to clone #{ssh_url}." }

    puts '=========================================='
    puts "Finished in #{Time.now - start_time} seconds." if start_time
  end
end
