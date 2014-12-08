module GitMulticast
  describe TaskRunner do

    subject(:runner) { described_class.new(actions) }

    let(:actions) { [hey_action, ho_action] }

    let(:hey_action) { ->() { first_result } }
    let(:ho_action) { ->() { second_result } }

    let!(:first_result) { TaskResult.new(:one, 'Hey!', 1) }
    let!(:second_result) { TaskResult.new(:two, 'Ho!', 1) }

    let(:formatter) { OutputFormatter.new }

    before do
      allow(OutputFormatter).to receive(:new)
        .and_return(formatter)
    end

    describe '#run!' do
      subject(:run!) { runner.run! }

      it 'creates a thread for each action'do
        expect(Thread).to receive(:new)
          .exactly(actions.size).times
          .and_call_original

        run!
      end

      it 'calls each action' do
        expect(hey_action).to receive(:call)
          .and_call_original
        expect(ho_action).to receive(:call)
          .and_call_original

        run!
      end

      it 'formats each output' do
        expect(formatter).to receive(:single_format)
          .with(first_result)
          .and_call_original
        expect(formatter).to receive(:single_format)
          .with(second_result)
          .and_call_original

        run!
      end
    end
  end
end
