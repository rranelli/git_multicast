describe GitMassDo::RepositoryFetcher do
  subject(:fetcher) { GitMassDo::RepositoryFetcher }

  describe '.get_repo' do
    subject(:get_repo) { fetcher.get_repo(url) }

    let(:url) { 'http://example.com/foo/bar/33' }
    let(:uri) { URI(url) }

    let(:response) { instance_double(Net::HTTPResponse) }
    let(:body) { '{"value": "I be a body"}' }

    let(:json) { { 'value' => 'I be a body' } }

    before do
      allow(JSON).to receive(:parse).and_return(json)

      allow(Net::HTTP).to receive(:get_response).and_return(response)
      allow(response).to receive(:body).and_return(body)
    end

    it 'calls get' do
      expect(Net::HTTP).to receive(:get_response).with(uri)

      get_repo
    end

    it 'parses the result json' do
      expect(response).to receive(:body)
      expect(JSON).to receive(:parse).with(body)

      get_repo
    end

    it 'Makes a struct with the result body' do
      expect(RecursiveOpenStruct).to receive(:new).with(
        json, recurse_over_arrays: true
      )

      get_repo
    end
  end

  describe '.get_response' do
  end

  describe '.make_struct' do
  end

  describe '.get_all_repos_from_user' do
  end
end
