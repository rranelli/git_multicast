module GitMassDo
  describe Cloner do
    subject(:cloner) { described_class.new(username, dir) }

    let(:username) { 'ironman' }
    let(:dir) { '/kifita/' }

    let(:repo) do
      double(
        :repo,
        ssh_url: 'git@hubgit.com:bar/foo',
        url: 'http://hubgit.com/bar/foo',
        fork: false,
        name: 'foo')
    end
    let(:repos) { [repo] * 3 }

    before do
      allow(cloner).to receive(:spawn).and_return(nil)
      allow(cloner).to receive(:waitall).and_return([])

      allow(RepositoryFetcher).to receive(:get_all_repos_from_user)
        .and_return(repos)
      allow(OutputFormatter).to receive(:format)
    end

    describe '#clone!' do
      subject(:clone!) { cloner.clone! }

      it 'spawns a clone job for each repo' do
        expect(cloner).to receive(:spawn)
          .with("git clone #{repo.ssh_url} /kifita/foo").exactly(3).times

        clone!
      end

      context 'when repo is a fork'do
        let(:parent_repo) do
          double(:parent, ssh_url: 'git@hubgit.com:parent/repo')
        end

        before do
          allow(RepositoryFetcher).to receive(
            :get_repo_parent
          ).and_return(parent_repo)

          allow(repo).to receive(:fork).and_return(true)
        end

        it 'gets parent repository by url' do
          expect(RepositoryFetcher).to receive(:get_repo_parent)
            .with(repo.url)

          clone!
        end

        it 'adds upstream remote' do
          expect(cloner).to receive(:spawn)
            .with(
            "git clone #{repo.ssh_url} /kifita/foo && \
git -C \"/kifita/foo\" remote add upstream #{parent_repo.ssh_url} \
--fetch"
            )

          clone!
        end
      end
    end
  end
end
