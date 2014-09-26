module GitMulticast
  describe Statuser do
    subject(:statuser) { described_class.new(dir) }

    let(:dir) { '/ki/fita/' }
    let(:entries) { ['fita1', 'fita2'] }

    let(:pipe) { IO.pipe }
    let(:r) { pipe.first }
    let(:w) { pipe[1] }

    before do
      $stdout = StringIO.new

      allow(statuser).to receive(:spawn).and_return(nil)
      allow(statuser).to receive(:waitall).and_return(
        [[nil, double(:success, success?: true)]] * 32
      )

      allow(IO).to receive(:pipe).and_return([r, w])
      allow(File).to receive(:directory?).and_return(true)
      allow(Dir).to receive(:entries).and_return(entries)

      allow(OutputFormatter).to receive(:format)
    end

    after do
      $stdout = STDOUT
    end

    describe '#get_statuses' do
      subject(:get_statuses) { statuser.get_statuses }

      it 'spawns a clone job for each repo' do
        entries.each do |entry|
          expect(statuser).to receive(:spawn)
            .with("cd #{entry} && git status", out: w, err: w)
        end

        get_statuses
      end
    end
  end
end
