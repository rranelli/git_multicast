module GitMulticast
  describe RepositoryFetcher do
    subject(:fetcher) { described_class }

    let(:fetchers) { described_class::FETCHERS }
    let(:username) { 'rranelli' }

    describe '.get_all_repos_from_user' do
      subject(:get_all_repos_from_user) do
        fetcher.get_all_repos_from_user(username)
      end

      it 'gets repositories from all fetchers' do
        VCR.use_cassette('repos_from_all_services') do
          fetchers.each do |fetcher|
            expect(fetcher).to receive(:get_all_repos_from_user)
              .with(username).and_call_original
          end

          get_all_repos_from_user
        end
      end

      it 'aggregates all repositories in a single list' do
        VCR.use_cassette('repos_from_all_services') do
          repo_names = get_all_repos_from_user.map(&:name)

          expect(get_all_repos_from_user.size).to eq(32)
          expect(repo_names).to include('git_multicast')
          expect(repo_names).to include('CronoFaker')
        end
      end
    end

    describe '.get_repo_parent' do
      subject(:get_repo_parent) { fetcher.get_repo_parent(url) }

      let(:url) do
        'https://api.github.com/repos/rranelli/git_multicast'
      end

      it 'delegates to the right fetcher' do
        VCR.use_cassette('github_repo') do
          expect(RepositoryFetcher::Github).to receive(:get_repo)
            .with(url).and_call_original

          get_repo_parent
        end
      end

      it 'adapts with the right adapter' do
        VCR.use_cassette('github_repo') do
          expect(Adapters::Github).to receive_message_chain(
            :new, :adapt, :parent
          )

          get_repo_parent
        end
      end

      it 'gets no parent when repo has no parent' do
        VCR.use_cassette('github_repo') do
          is_expected.to be_nil
        end
      end

      context 'when repository has a parent' do
        let(:url) do
          'https://api.github.com/repos/rranelli/ruby-git-hooks'
        end

        it 'gets the parent' do
          VCR.use_cassette('github_repo_parent') do
            upstream_repo_owner = get_repo_parent.owner.login

            expect(upstream_repo_owner).to eq('stupied4ever')
          end
        end
      end
    end

    describe '.get_repo' do
      subject(:get_repo) { fetcher.get_repo(url) }

      let(:url) do
        'https://bitbucket.org/api/2.0/repositories/rranelli/cronofaker'
      end

      let(:bb_adapter) { double(:bb_adapter, adapt: nil) }

      it 'delegates to the right fetcher' do
        VCR.use_cassette('bitbucket_repo') do
          expect(RepositoryFetcher::Bitbucket).to receive(:get_repo)
            .with(url).and_call_original

          get_repo
        end
      end

      it 'adapts with the right adapter' do
        VCR.use_cassette('bitbucket_repo') do
          expect(Adapters::Bitbucket).to receive(:new).and_return(bb_adapter)
          expect(bb_adapter).to receive(:adapt)

          get_repo
        end
      end

      it 'gets the repository' do
        VCR.use_cassette('bitbucket_repo') do
          expect(get_repo.name).to eq('CronoFaker')
        end
      end
    end
  end
end
