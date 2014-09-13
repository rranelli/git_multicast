module GitMulticast
  describe Cloner do
    subject(:cloner) { described_class.new(username, dir) }

    let(:username) { 'rranelli' }
    let(:dir) { '/kifita/' }

    let(:repo_name) { 'git_multicast' }

    let(:pipe) { IO.pipe }
    let(:r) { pipe.first }
    let(:w) { pipe[1] }

    before do
      allow(cloner).to receive(:spawn).and_return(nil)
      allow(cloner).to receive(:waitall).and_return(
        [[nil, double(:success, success?: true)]] * 32
      )

      allow(IO).to receive(:pipe).and_return([r, w])

      allow(OutputFormatter).to receive(:format)
    end

    describe '#clone!' do
      subject(:clone!) { cloner.clone! }

      it 'spawns a clone job for each repo' do
        VCR.use_cassette('clone_repos') do
          expect(cloner).to receive(:spawn).exactly(32).times

          clone!
        end
      end

      it 'spawns a clone with the right parameters' do
        VCR.use_cassette('clone_repos') do
          expect(cloner).to receive(:spawn)
            .with("git clone git@github.com:rranelli/#{repo_name}.git" \
            ' /kifita/git_multicast', out: w, err: w)

          clone!
        end
      end

      context 'when repo is a fork'do
        let(:repo_name) { 'git-hooks' }

        it 'adds upstream remote' do
          VCR.use_cassette('clone_repos') do
            expect(cloner).to receive(:spawn)
              .with(
              "git clone git@github.com:rranelli/ruby-#{repo_name}.git " \
              "/kifita/ruby-#{repo_name} && git -C \"/kifita/ruby-#{repo_name}\"" \
              ' remote add upstream ' \
              "git@github.com:stupied4ever/#{repo_name}.git --fetch",
              out: w, err: w)

            clone!
          end
        end
      end
    end
  end
end
