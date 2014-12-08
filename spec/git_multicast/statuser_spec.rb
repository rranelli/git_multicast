module GitMulticast
  describe Statuser do
    subject(:statuser) { described_class.new(dir) }

    let(:dir) { '/ki/fita/' }
    let(:entries) { ['fita1', 'fita2'] }

    let(:task) { instance_double(Task, call: result) }
    let(:result) { TaskResult.new('fitas', 'success', 0) }

    before do
      allow(File).to receive(:directory?).and_return(true)
      allow(Dir).to receive(:entries).and_return(entries)

      allow(Task).to receive(:new)
        .and_return(task)
    end

    describe '#statuses!' do
      subject(:statuses!) { statuser.statuses! }

      it 'creates a task for each repository' do
        entries.each do |entry|
          expect(Task).to receive(:new)
            .with(entry, "cd #{entry} && git status")
        end

        statuses!
      end

      it 'runs those tasks using a runner' do
        expect(TaskRunner).to receive(:new)
          .with([task, task]).and_call_original

        statuses!
      end
    end
  end
end
