#!/usr/bin/env ruby

include Process

class Array
  def second
    self[1]
  end
end

def format_result(repositories, statuses)
  repositories.zip(statuses).each do |repo, status|
    puts "Pulled #{repo} successfully" if status && status.success?
    puts "Failed to pull #{repo}" unless status && status.success?
  end
end

dirs = Dir.entries(Dir.pwd)
  .select { |f| File.directory? f }
  .reject { |f| f =~ /^\./  } # ., .. and .git and the like

dirs.each do |dir|
  spawn "git -C #{dir} pull origin"
end

resutlt = waitall

statuses = resutlt.map(&:second)

format_result(dirs, statuses)
