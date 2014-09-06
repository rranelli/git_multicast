module GitMulticast
  class OutputFormatter
    def self.format(repos, statuses, start_time = nil)
      repo_status_pairs = repos.zip(statuses)

      # get successes and failures
      success_pairs = repo_status_pairs.select { |_, status| status.success? }
      failure_pairs = repo_status_pairs.reject { |_, status| status.success? }

      success_pairs.each { |repo, _| puts "#{repo.name} cloned successfully." }
      failure_pairs.each { |repo, _|  puts "failure to clone #{repo.name}." }

      puts '=========================================='
      puts "Finished in #{Time.now - start_time} seconds." if start_time
    end
  end
end
