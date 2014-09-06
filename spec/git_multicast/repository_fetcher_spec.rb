module GitMulticast
  describe RepositoryFetcher do
    subject(:fetcher) { described_class }

    let(:fetchers) { described_class::FETCHERS }

    let(:username) { 'chuck norris' }

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

      it 'delegates to the right fetcher' do
        expect(RepositoryFetcher::Bitbucket).to receive(:get_repo_parent).with(url)

        get_repo_parent
      end
    end
  end
end
