module GitMulticast
  class Task
    Result = Struct.new(:name, :result, :exit_status) do
      def to_s
        result
      end

      def success?
        exit_status.zero?
      end
    end
  end
end
