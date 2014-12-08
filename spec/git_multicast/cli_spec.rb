require 'git_multicast/cli'

module GitMulticast
  describe Cli do
    subject(:cli) { described_class.new }

    before do
      $stdout = StringIO.new
    end

    after do
      $stdout = STDOUT
    end

    describe '#pull' do
      subject(:pull) { cli.pull }

      it do
        expect(Puller).to receive_message_chain(:new, :pull!)

        pull
      end
    end

    describe '#status' do
      subject(:status) { cli.status }

      it do
        expect(Statuser).to receive_message_chain(:new, :statuses!)

        status
      end
    end

    describe '#clone' do
      subject(:clone) { cli.clone(username) }

      let(:username) { 'someone' }

      it do
        expect(Cloner).to receive_message_chain(:new, :clone!)

        clone
      end
    end
  end
end
