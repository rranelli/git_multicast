module GitMulticast
  class Task
    describe Runner do
      subject(:runner) { described_class.new(tasks) }

      let(:tasks) { [hey_task, ho_task] }

      # Since tasks quack like lambdas, I will be using them here.
      let(:hey_task) { ->() { sleep(0.3) && first_result } }
      let(:ho_task) { ->() { sleep(0.3) && second_result } }

      let(:first_result) { Task::Result.new(:one, 'Hey!', 1) }
      let(:second_result) { Task::Result.new(:two, 'Ho!', 1) }

      describe '#run!' do
        subject(:run!) { runner.run! }

        it 'calls each task' do
          expect(hey_task).to receive(:call)
            .and_call_original
          expect(ho_task).to receive(:call)
            .and_call_original

          run!

          sleep(0.5)
        end

        it 'returns an array with task results' do
          timeout(0.5) do
            expect(run!).to contain_exactly(first_result, second_result)
          end
        end
      end
    end
  end
end
