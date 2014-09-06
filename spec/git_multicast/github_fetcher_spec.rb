describe GitMulticast::GithubFetcher do
  subject(:fetcher) { described_class }

  let(:uri) { URI(url) }
  let(:response) { instance_double(Net::HTTPResponse) }
  let(:body) { '{"value": "I be a body", "b": "c"}' }

  let(:json) { { 'value' => 'I be a body', 'b' => 'c' } }

  before do
    allow(JSON).to receive(:parse).and_return(json)

    allow(Net::HTTP).to receive(:get_response).and_return(response)
    allow(response).to receive(:body).and_return(body)
  end

  describe '.get_repo' do
    subject(:get_repo) { fetcher.get_repo(url) }

    let(:url) { 'http://example.com/foo/bar/33' }

    it 'calls http get' do
      expect(Net::HTTP).to receive(:get_response).with(uri)

      get_repo
    end

    it 'parses the resulting json' do
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

  describe '.get_all_repos_from_user' do
    subject(:get_all_repos_from_user) { fetcher.get_all_repos_from_user(user) }

    let(:user) { 'mrwhite' }
    let(:url) { 'https://api.github.com/users/mrwhite/repos' }

    let(:json) do
      [
        { 'value' => 'I be a body' },
        { 'b' => 'c' }
      ]
    end

    it 'calls http get' do
      expect(Net::HTTP).to receive(:get_response).with(uri)

      get_all_repos_from_user
    end

    it 'parses the resulting json' do
      expect(JSON).to receive(:parse).with(body)

      get_all_repos_from_user
    end

    it 'builds each repository as an OpenStruct' do
      expect(RecursiveOpenStruct).to receive(:new).twice

      get_all_repos_from_user
    end
  end
end
