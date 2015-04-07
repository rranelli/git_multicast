require_relative 'task/result'
require_relative 'task/runner'
require_relative 'task/pool'

module GitMulticast
  class Task
    include Process

    def initialize(description, command)
      @description, @command = description, command
    end

    def run!
      r, w = IO.pipe
      pid = spawn(command, out: w, err: w)

      _, status = wait2(pid)
      w.close unless w.closed?

      Result.new(description, r.read, status.exitstatus)
    ensure
      w.close unless w.closed?
    end

    alias_method :call, :run!

    protected

    attr_reader :description, :command
  end
end
