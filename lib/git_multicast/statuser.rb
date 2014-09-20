module GitMulticast
  class Statuser
    include Process

    attr_reader :dir

    def initialize(dir)
      @dir = dir
    end

    def get_statuses
      start_time = Time.now
      output_status_zip = statuses

      OutputFormatter.format(output_status_zip, start_time)
    end

    def statuses
      dirs = Dir.entries(dir)
        .select { |f| File.directory? f }
        .reject { |f| f =~ /^\./  } # ., .. and .git and the like

      streams = dirs.map do |dir|
        r, w = IO.pipe
        w.write("Repo: #{dir}\n")
        spawn("cd #{dir} && git status", out: w, err: w)
        [r, w]
      end
      _, statuses = waitall.transpose

      output = read_output(streams)
      output.zip(statuses)
    end

    def read_output(streams)
      streams.map do |r, w|
        w.close unless w.closed?
        r.read
      end
    end
  end
end
