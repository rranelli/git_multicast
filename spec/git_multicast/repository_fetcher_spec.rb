describe GitMulticast::RepositoryFetcher do
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

  describe 'self.get_parent_repo' do
    subject(:get_parent_repo) { fetcher.get_parent_repo(url) }

    let(:url) { 'http://bitbucket.im.wrong.as.hell' }

    it 'delegates to the right fetcher' do
      expect(GitMulticast::BitbucketFetcher).to receive(:get_parent_repo).with(url)

      get_parent_repo
    end
  end
end
