describe GitMulticast::Task do
  subject(:task) { described_class.new(description, command) }

  let(:description) { 'some echo' }
  let(:command) { 'echo hi' }

  let(:pid) { 42 }
  let(:status) { instance_double(Process::Status, exitstatus: 0) }

  let(:pipe) { IO.pipe }
  let(:r) { pipe.first }
  let(:w) { pipe[1] }

  before do
    allow(STDOUT).to receive(:write)

    allow(task).to receive(:spawn)
      .and_return(pid)
    allow(task).to receive(:wait2)
      .and_return([0, status])
    allow(task).to receive(:wait)
      .and_return(['', 0])

    allow(IO).to receive(:pipe)
      .and_return([r, w])
    allow(r).to receive(:read)
      .and_return('I be output!')
  end

  describe '#run!' do
    subject(:run!) { task.run! }

    it 'creates an input and output stream' do
      expect(IO).to receive(:pipe)
        .and_call_original

      run!
    end

    it 'spawns a child process' do
      expect(task).to receive(:spawn)
        .with(command, out: w, err: w)

      run!
    end

    it 'waits for its process to finish' do
      expect(task).to receive(:wait2)
        .with(pid)

      run!
    end

    it 'wraps its result in a Task::Result object' do
      expect(GitMulticast::Task::Result).to receive(:new)
        .with(description, 'I be output!', 0)

      run!
    end

    it 'writes description to STDOUT' do
      expect(STDOUT).to receive(:write).with(description)

      run!
    end
  end
end
