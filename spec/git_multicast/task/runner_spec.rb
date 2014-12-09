module GitMulticast
  class Task
    describe Runner do
      subject(:runner) { described_class.new(tasks) }

      let(:tasks) { [hey_task, ho_task] }

      # Since tasks quack like lambdas, I will be using them here.
      let(:hey_task) { ->() { first_result } }
      let(:ho_task) { ->() { second_result } }

      let!(:first_result) { Task::Result.new(:one, 'Hey!', 1) }
      let!(:second_result) { Task::Result.new(:two, 'Ho!', 1) }

      let(:formatter) { Formatter::Standard.new }

      before do
        allow(Formatter::Standard).to receive(:new)
          .and_return(formatter)
      end

      describe '#run!' do
        subject(:run!) { runner.run! }

        it 'creates a thread for each task'do
          expect(Thread).to receive(:new)
            .exactly(tasks.size).times
            .and_call_original

          run!
        end

        it 'calls each task' do
          expect(hey_task).to receive(:call)
            .and_call_original
          expect(ho_task).to receive(:call)
            .and_call_original

          run!
        end
      end
    end
  end
end
