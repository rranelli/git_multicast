module GitMulticast
  class Multicaster
    describe Pull do
      subject(:puller) { described_class.new(dir) }

      let(:dir) { '/home/' }
      let(:entries) { %w(one two) }

      let(:task) { instance_double(Task, call: result) }
      let(:result) { TaskResult.new('fitas', 'success', 0) }

      before do
        allow(File).to receive(:directory?).and_return(true)
        allow(Dir).to receive(:entries).and_return(entries)

        allow(Task).to receive(:new)
          .and_return(task)
      end

      describe '#execute!' do
        subject(:execute!) { puller.execute! }

        it 'creates a task for each repository' do
          entries.each do |entry|
            expect(Task).to receive(:new)
              .with(entry, "git -C #{entry} pull -r origin")
          end

          execute!
        end

        it 'runs tasks using a runner' do
          expect(TaskRunner).to receive(:new)
            .with([task, task]).and_call_original

          execute!
        end
      end
    end
  end
end
