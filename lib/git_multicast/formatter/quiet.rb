require 'colorize'

module GitMulticast
  class Formatter
    class Quiet < Standard
      def format(task_result)
        return '' if task_result.success?

        super
      end
    end
  end
end
