module GitMulticast
  describe Adapter::Bitbucket do
    subject(:adapter) { described_class.new(repo) }

    describe '#adapt' do
      subject(:adapt) { adapter.adapt }

      let(:url) do
        'https://bitbucket.org/api/2.0/repositories/rranelli/cronofaker'
      end
      let(:repo) { RepositoryFetcher::Bitbucket.get_repo(url) }

      # I know this is ugly, but well...
      it do
        VCR.use_cassette('bitbucket_repo') do
          expect(adapt.url).to eq(
            'https://bitbucket.org/api/2.0/repositories/rranelli/cronofaker'
          )
          expect(adapt.ssh_url).to eq(
            'ssh://git@bitbucket.org/rranelli/cronofaker.git'
          )
          expect(adapt.name).to eq('CronoFaker')
          expect(adapt.fork).to be_falsy
          expect(adapt.parent).to be_nil
        end
      end
    end
  end
end
