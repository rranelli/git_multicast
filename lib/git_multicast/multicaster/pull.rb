module GitMulticast
  class Multicaster
    class Pull < Generic
      def initialize(dir, formatter = Formatter::Standard.new(Time.now))
        super(dir, 'pull -r origin', formatter)
      end
    end
  end
end
