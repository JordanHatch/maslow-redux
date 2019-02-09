require 'rails_helper'

RSpec.describe NeedPresenter do

  let(:need) { create(:need) }
  subject { described_class.new(need) }

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
      let(:need) { create(:need) }

      it 'is true' do
        expect(subject.show_actions?).to be_truthy
      end
    end

    context 'when the need is closed' do
      let(:need) { create(:closed_need) }

      it 'is false' do
        expect(subject.show_actions?).to be_falsey
      end
    end
  end

end
