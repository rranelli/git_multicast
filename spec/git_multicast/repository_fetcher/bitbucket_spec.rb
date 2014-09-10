module GitMulticast
  describe RepositoryFetcher::Bitbucket do
    subject(:fetcher) { described_class }

    describe '.get_repo' do
      subject(:get_repo) { fetcher.get_repo(url) }

      let(:url) do
        'https://bitbucket.org/api/2.0/repositories/rranelli/cronofaker'
      end
      let(:json) do
        { 'values' =>
          [
            { 'links' => { 'clone' => 'I be a body' } },
            { 'links' => { 'clone' => 'I be other body' } }
          ]
        }
      end

      before do
        allow(JSON).to receive(:parse).and_return(json)
      end

      it 'calls http get' do
        VCR.use_cassette('bitbucket_repository') do
          expect(Net::HTTP).to receive(:get_response)
            .with(URI(url)).and_call_original

          get_repo
        end
      end

      it 'parses the resulting json' do
        VCR.use_cassette('bitbucket_repository') do
          expect(JSON).to receive(:parse)

          get_repo
        end
      end

      it 'makes a struct with the result body' do
        VCR.use_cassette('bitbucket_repository') do
          expect(RecursiveOpenStruct).to receive(:new)
            .with(json, recurse_over_arrays: true)

          get_repo
        end
      end
    end

    describe '.get_all_repos_from_user' do
      subject(:get_all_repos_from_user) do
        fetcher.get_all_repos_from_user(user)
      end

      let(:user) { 'rranelli' }
      let(:url) { URI('https://bitbucket.org/api/2.0/repositories/rranelli') }

      it 'calls http get' do
        VCR.use_cassette('bitbucket_all_user_repos') do
          expect(Net::HTTP).to receive(:get_response)
            .with(url).and_call_original

          get_all_repos_from_user
        end
      end

      it 'parses the resulting json' do
        VCR.use_cassette('bitbucket_all_user_repos') do
          expect(JSON).to receive(:parse).and_call_original

          get_all_repos_from_user
        end
      end

      it 'builds each repository as a RecursiveOpenStruct' do
        VCR.use_cassette('bitbucket_all_user_repos') do
          expect(RecursiveOpenStruct).to receive(:new).exactly(3).times

          get_all_repos_from_user
        end
      end
    end
  end
end
