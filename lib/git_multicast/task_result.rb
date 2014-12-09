module GitMulticast
  TaskResult = Struct.new(:name, :result, :exit_status) do
    def to_s
      result
    end

    def success?
      exit_status.zero?
    end
  end
end
