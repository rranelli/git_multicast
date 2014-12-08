module GitMulticast
  TaskResult = Struct.new(:name, :result, :exit_status) do
    def to_s
      result
    end
  end
end
