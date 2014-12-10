module GitMulticast
  class Multicaster
    class Status < Multicaster
      def initialize(dir, formatter = Formatter::Status.new(Time.now))
        @dir = dir

        super(formatter)
      end

      protected

      attr_reader :dir

      def tasks
        Dir.entries(dir)
          .select { |f| File.directory? f }
          .reject { |f| f =~ /^\./  } # ., .. and .git and the like
          .map { |dir| Task.new(description(dir), command(dir)) }
      end

      def command(dir)
        "cd #{dir} && git status"
      end

      def description(dir)
        File.basename(dir)
      end
    end
  end
end
