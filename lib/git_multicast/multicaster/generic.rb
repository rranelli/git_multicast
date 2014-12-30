module GitMulticast
  class Multicaster
    class Generic < Multicaster
      def initialize(dir, command, formatter = Formatter::Standard.new(Time.now))
        @dir = dir
        @command = command

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
        "git -C #{dir} #{@command}"
      end

      def description(dir)
        File.basename(dir)
      end
    end
  end
end
