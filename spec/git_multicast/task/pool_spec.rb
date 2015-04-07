describe GitMulticast::Task::Pool do
  subject(:pool) { described_class.new(size) }

  let(:size) { 5 }

  it { is_expected.to be_truthy }

  describe '#schedule' do
    subject(:schedule) { pool.schedule(1, &appender) }

    let(:result) { [] }
    let(:appender) { -> (x) { result << x } }

    it do
      schedule
      sleep(0.3)

      expect(result).to eq([1])
    end

    context 'when scheduling many jobs' do
      subject(:schedule) do
        jobs.each { |(*args, job)| pool.schedule(*args, &job) }
      end

      let(:append_and_sleep) { -> (x) { (result << x) && sleep(0.5) } }

      let(:jobs) do
        [
          [1, append_and_sleep],
          [2, append_and_sleep],
          [3, append_and_sleep],
          [4, append_and_sleep],
          [5, append_and_sleep]
        ]
      end

      it 'runs them in parallel' do
        schedule
        sleep(0.2)

        expect(result).to contain_exactly(1, 2, 3, 4, 5)
      end
    end
  end
end
