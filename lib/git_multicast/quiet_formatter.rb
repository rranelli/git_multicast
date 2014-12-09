require 'colorize'

module GitMulticast
  class QuietFormatter < OutputFormatter
    def format(task_result)
      return '' if task_result.success?

      super
    end
  end
end
