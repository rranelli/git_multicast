module GitMulticast
  describe RepositoryFetcher do
    subject(:fetcher) { described_class }

    let(:fetchers) { described_class::FETCHERS }
    let(:username) { 'chuck norris' }

    let(:repo) { double(:repo, parent: double(:parent)) }

    let(:bb_adapter) { double(:bb_adapter, adapt: nil) }
    let(:gh_adapter) { double(:gh_adapter, adapt: nil) }

    describe '.get_all_repos_from_user' do
      subject(:get_all_repos_from_user) do
        fetcher.get_all_repos_from_user(username)
      end

      it 'gets repositories from all fetchers' do
        fetchers.each do |e|
          expect(e).to receive(:get_all_repos_from_user)
        end

        get_all_repos_from_user
      end
    end

    describe 'self.get_repo_parent' do
      subject(:get_repo_parent) { fetcher.get_repo_parent(url) }

      let(:url) { 'http://bitbucket.im.wrong.as.hell' }

      before do
        allow(RepositoryFetcher::Bitbucket).to receive(:get_repo)
          .and_return(repo)
        allow(Adapters::Bitbucket).to receive(:new).and_return(bb_adapter)
        allow(Adapters::Github).to receive(:new).and_return(gh_adapter)
      end

      it 'delegates to the right fetcher' do
        expect(RepositoryFetcher::Bitbucket).to receive(:get_repo).with(url)
        expect(repo).to receive(:parent)

        get_repo_parent
      end

      it 'adapts with the right adapter' do
        expect(bb_adapter).to receive(:adapt)

        get_repo_parent
      end
    end

    describe 'self.get_repo' do
      subject(:get_repo) { fetcher.get_repo(url) }

      let(:url) { 'http://github.im.right.as.heaven.but.not' }

      before do
        allow(RepositoryFetcher::Github).to receive(:get_repo).and_return(repo)
        allow(Adapters::Bitbucket).to receive(:new).and_return(bb_adapter)
        allow(Adapters::Github).to receive(:new).and_return(gh_adapter)
      end

      it 'delegates to the right fetcher' do
        expect(RepositoryFetcher::Github).to receive(:get_repo).with(url)

        get_repo
      end

      it 'adapts with the right adapter' do
        expect(gh_adapter).to receive(:adapt)

        get_repo
      end
    end
  end
end
