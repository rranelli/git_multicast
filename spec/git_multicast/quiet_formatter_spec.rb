module GitMulticast
  describe QuietFormatter do
    subject(:formatter) { described_class.new }

    let(:name) { "some action" }
    let(:status) { 0 }
    let(:result_string) { "stuff to be done" }

    let(:result) { TaskResult.new(name, result_string, status) }

    describe '.format' do
      subject(:format) { formatter.format(result) }

      it do
        is_expected.to match(/^$/)
      end

      context 'when exit_status is not 0' do
        let(:status) { 999 }

        it do
          is_expected.to match(/\[Error\]/)
            .and match(/#{result}/)
        end
      end
    end
  end
end
