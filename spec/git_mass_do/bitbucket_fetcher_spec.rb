describe GitMassDo::BitbucketFetcher do
  subject(:fetcher) { described_class }

  let(:uri) { URI(url) }
  let(:response) { instance_double(Net::HTTPResponse) }
  let(:body) do
    '{ "values": [\
{ "links": { "clone": "I be a body" } },\
{ "links": { "clone": "I be other body" } }\
]}'
  end

  let(:json) do
    { 'values' =>
      [
        { 'links' => { 'clone' => 'I be a body' } },
        { 'links' => { 'clone' => 'I be other body' } }
      ]
    }
  end

  let(:adapter) do
    instance_double(GitMassDo::BitbucketAdapter, adapt: adapted_repo)
  end
  let(:adapted_repo) { double(:adapted_repo) }

  before do
    allow(JSON).to receive(:parse).and_return(json)

    allow(Net::HTTP).to receive(:get_response).and_return(response)
    allow(response).to receive(:body).and_return(body)

    allow(GitMassDo::BitbucketAdapter).to receive(:new).and_return(adapter)
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

    it 'makes a struct with the result body' do
      expect(RecursiveOpenStruct).to receive(:new).with(
        json, recurse_over_arrays: true
      )

      get_repo
    end

    it 'adapts result to the standard interface' do
      expect(adapter).to receive(:adapt)
      is_expected.to eq(adapted_repo)
    end
  end

  describe '.get_all_repos_from_user' do
    subject(:get_all_repos_from_user) { fetcher.get_all_repos_from_user(user) }

    let(:user) { 'mrwhite' }
    let(:url) { 'https://bitbucket.org/api/2.0/repositories/mrwhite' }

    it 'calls http get' do
      expect(Net::HTTP).to receive(:get_response).with(uri)

      get_all_repos_from_user
    end

    it 'parses the resulting json' do
      expect(JSON).to receive(:parse).with(body)

      get_all_repos_from_user
    end

    it 'builds each repository as a RecursiveOpenStruct' do
      expect(RecursiveOpenStruct).to receive(:new).twice

      get_all_repos_from_user
    end

    it 'adapts each struct' do
      expect(adapter).to receive(:adapt).twice

      get_all_repos_from_user
    end
  end
end
