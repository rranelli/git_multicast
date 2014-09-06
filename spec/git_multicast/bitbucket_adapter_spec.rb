describe GitMulticast::BitbucketAdapter do
  subject(:adapter) { described_class.new(repo) }

  let(:repo) { double(:repo) }

  before do
    allow(repo).to receive_message_chain(:links, :_clone, :last, :href)
      .and_return('git@bucketbit.org:foo/bar.git')
    allow(repo).to receive_message_chain(:links, :self, :href)
      .and_return('http://bucketbit.org/test-repo')

    allow(repo).to receive(:name).and_return('test-repo')
    allow(repo).to receive(:parent).and_return(nil)
  end

  describe '#adapt' do
    subject(:adapt) { adapter.adapt }

    it { expect(adapt.name).to eq('test-repo') }
    it { expect(adapt.fork).to be_falsy }
    it { expect(adapt.url).to eq('http://bucketbit.org/test-repo') }
    it { expect(adapt.ssh_url).to eq('git@bucketbit.org:foo/bar.git') }
    it { expect(adapt.parent).to be_nil }
  end
end
