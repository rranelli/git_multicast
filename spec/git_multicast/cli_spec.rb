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
        expect(Multicaster::Pull).to receive_message_chain(:new, :execute!)

        pull
      end
    end

    describe '#status' do
      subject(:status) { cli.status }

      it do
        expect(Multicaster::Status).to receive_message_chain(:new, :execute!)

        status
      end
    end

    describe '#clone' do
      subject(:clone) { cli.clone(username) }

      let(:username) { 'someone' }

      it do
        expect(Multicaster::Clone).to receive_message_chain(:new, :execute!)

        clone
      end
    end
  end
end
