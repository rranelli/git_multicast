require 'colorize'

module GitMulticast
  class QuietFormatter < OutputFormatter
    def format(task_result)
      return '' if task_result.exit_status.zero?

      super
    end
  end
end
