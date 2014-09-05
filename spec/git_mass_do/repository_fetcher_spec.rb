describe GitMassDo::RepositoryFetcher do
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
end
