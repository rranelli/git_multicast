module GitMulticast
  class Task
    include Process

    def initialize(description, command)
      @description, @command = description, command
    end

    def run!
      r, w = IO.pipe
      w.write("Running: #{description}\n")
      pid = spawn(command, out: w, err: w)

      _, exit_status = wait(pid)
      w.close unless w.closed?

      TaskResult.new(description, r.read, exit_status)
    ensure
      w.close unless w.closed?
    end

    alias_method :call, :run!

    protected

    attr_reader :description, :command
  end
end
