describe GitMassDo::Puller do
  subject(:puller) { described_class.new(dir) }

  let(:dir) { '/home/' }
  let(:entries) { %w(one two) }

  let(:success) { double(:success, success?: true) }

  before do
    $stdout = StringIO.new

    allow(File).to receive(:directory?).and_return(true)
    allow(Dir).to receive(:entries).and_return(entries)

    allow(puller).to receive(:spawn).and_return(nil)
    allow(puller).to receive(:waitall).and_return([[1, success], [2, success]])
  end

  describe '#pull' do
    subject(:pull) { puller.pull }

    it 'issues a git pull command for each entry in dir' do
      entries.each do |entry|
        expect(puller).to receive(:spawn).with("git -C #{entry} pull origin")
      end

      pull
    end

    it 'formats results' do
      expect { pull }.to output(
        "Pulled one successfully\nPulled two successfully\n"
      ).to_stdout
    end

    context 'with error output' do
      before do
        allow(puller).to receive(:waitall)
          .and_return([[1, success], [2, nil]])
      end

      it 'formats results correctly when there is an error in a job' do
        expect { pull }.to output(
          "Pulled one successfully\nFailed to pull two\n"
        ).to_stdout

        pull
      end
    end
  end
end
