module GitMulticast
  describe RepositoryFetcher::Github do
    subject(:fetcher) { described_class }

    let(:uri) { URI(url) }

    describe '.get_repo' do
      subject(:get_repo) { fetcher.get_repo(url) }

      let(:url) { 'http://github.com/rranelli/git_multicast.git' }
      let(:json) do
        { 'value' => 'I be a body' }
      end

      before do
        allow(JSON).to receive(:parse).and_return(json)
      end

      it 'calls http get' do
        VCR.use_cassette('github_repo') do
          expect(Net::HTTP).to receive(:get_response)
            .with(uri).and_call_original

          get_repo
        end
      end

      it 'parses the resulting json' do
        VCR.use_cassette('github_repo') do
          expect(JSON).to receive(:parse)

          get_repo
        end
      end

      it 'Makes a struct with the result body' do
        VCR.use_cassette('github_repo') do
          expect(RecursiveOpenStruct).to receive(:new).with(
            json, recurse_over_arrays: true
          )

          get_repo
        end
      end
    end

    describe '.get_all_repos_from_user' do
      subject(:get_all_repos_from_user) do
        fetcher.get_all_repos_from_user(user)
      end

      let(:user) { 'rranelli' }
      let(:url) { 'https://api.github.com/users/rranelli/repos' }

      it 'calls http get' do
        VCR.use_cassette('github_all_user_repos') do
          expect(Net::HTTP).to receive(:get_response)
            .with(uri).and_call_original

          get_all_repos_from_user
        end
      end

      it 'parses the resulting json' do
        VCR.use_cassette('github_all_user_repos') do
          expect(JSON).to receive(:parse).and_call_original

          get_all_repos_from_user
        end
      end

      it 'builds each repository as an OpenStruct' do
        VCR.use_cassette('github_all_user_repos') do
          expect(RecursiveOpenStruct).to receive(:new).exactly(29).times

          get_all_repos_from_user
        end
      end
    end
  end
end
