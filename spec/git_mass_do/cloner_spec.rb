module GitMassDo
  describe Cloner do
    subject(:cloner) { described_class.new(username) }

    let(:username) { 'ironman' }

    let(:repo) { double(:repo, ssh_url: 'git@hubgit.com:foo/bar', fork: false) }
    let(:repos) { [repo] * 3 }

    before do
      allow(cloner).to receive(:spawn).and_return(nil)
      allow(cloner).to receive(:waitall).and_return([])
    end

    describe '#clone_em_all!' do
      subject(:clone_em_all!) { cloner.clone_em_all!(repos) }

      it 'spawns a clone job for each repo' do
        expect(cloner).to receive(:spawn)
          .with("git clone #{repo.ssh_url}").exactly(3).times

        clone_em_all!
      end

      context 'when repo is a fork'do
        let(:repo) do
          double(
            :repo,
            ssh_url: 'git@hubgit.com:bar/foo',
            url: 'http://hubgit.com/bar/foo',
            fork: true,
            name: 'bar'
          )
        end

        let(:parent_repo) do
          double(:parent, ssh_url: 'git@hubgit.com:parent/repo')
        end

        before do
          allow(RepositoryFetcher).to receive_message_chain(
            :get_repo, :parent
          ).and_return(parent_repo)
        end

        it 'gets parent repository by url' do
          expect(RepositoryFetcher).to receive(:get_repo)
            .with(repo.url)

          clone_em_all!
        end

        it 'adds upstream remote' do
          expect(cloner).to receive(:spawn)
            .with(
            "git clone #{repo.ssh_url} && \
git -C #{repo.name} remote add upstream #{parent_repo.ssh_url} \
--fetch"
            )

          clone_em_all!
        end
      end
    end
  end
end
