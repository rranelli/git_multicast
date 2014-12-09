module GitMulticast
  describe OutputFormatter do
    subject(:formatter) { described_class.new }

    let(:name) { "some action" }
    let(:exit_status) { 0 }
    let(:result_string) { "stuff to be done" }

    let(:result) { TaskResult.new(name, result_string, exit_status) }

    describe '.format' do
      subject(:format) { formatter.format(result) }

      it do
        is_expected.to match(/\[Success\]/)
          .and match(/#{name}/)
      end

      context 'when exit_status is not 0' do
        let(:exit_status) { 999 }

        it do
          is_expected.to match(/\[Error\]/)
            .and match(/#{result}/)
        end
      end
    end
  end
end
