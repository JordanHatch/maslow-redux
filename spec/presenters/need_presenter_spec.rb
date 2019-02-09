require 'rails_helper'

RSpec.describe NeedPresenter do

  let(:need) { create(:need) }
  let(:mock_context) { double("ViewContext") }

  subject { described_class.new(need, mock_context) }

  describe '#show_proposition_statements?' do
    context 'when proposition statements exist' do
      before { create(:proposition_statement) }

      it 'is true' do
        expect(subject.show_proposition_statements?).to be_truthy
      end
    end

    context 'when proposition statements do not exist' do
      before { PropositionStatement.delete_all }

      it 'is false' do
        expect(subject.show_proposition_statements?).to be_falsey
      end
    end
  end

  describe '#show_tags?' do
    context 'when tag types exist' do
      before { create(:tag_type) }

      it 'is true' do
        expect(subject.show_tags?).to be_truthy
      end
    end

    context 'when proposition statements do not exist' do
      before { TagType.delete_all }

      it 'is false' do
        expect(subject.show_tags?).to be_falsey
      end
    end
  end

  describe '#show_actions?' do
    context 'when the need is open' do
      let(:need) { build_stubbed(:need) }
      
      before {
        allow(mock_context).to receive(:current_user)
                                .and_return(current_user)
      }

      context 'and the current user can close a need' do
        let(:current_user) { build_stubbed(:admin_user) }

        it 'is true' do
          expect(subject.show_actions?).to be_truthy
        end
      end

      context 'and the current user cannot close a need' do
        let(:current_user) { build_stubbed(:user) }

        it 'is false' do
          expect(subject.show_actions?).to be_falsey
        end
      end
    end

    context 'when the need is closed' do
      let(:need) { build_stubbed(:closed_need) }

      it 'is false' do
        expect(subject.show_actions?).to be_falsey
      end
    end
  end

end
