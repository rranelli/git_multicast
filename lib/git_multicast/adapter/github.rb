module GitMulticast
  module Adapter
    class Github
      def initialize(repo)
        @repo = repo
      end

      def adapt
        repo
      end

      protected

      attr_reader :repo
    end
  end
end
