module GitMulticast
  class Formatter
    describe Status do
      subject(:formatter) { described_class.new }

      let(:name) { 'some action' }
      let(:exit_status) { 0 }
      let(:result_string) { '"git add' }

      let(:result) { Task::Result.new(name, result_string, exit_status) }

      describe '#format' do
        subject(:format) { formatter.format(result) }

        it do
          is_expected.to match(/\[No Changes\]/)
            .and match(/#{name}/)
        end

        context 'when there are changes in the working directory' do
          let(:result_string) { '"git add ' }

          it do
            is_expected.to match(/\[Changes\]/)
              .and match(/#{name}/)
              .and match(/#{result}/)
          end
        end
      end
    end
  end
end
