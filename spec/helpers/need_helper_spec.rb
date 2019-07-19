require 'rails_helper'

RSpec.describe NeedHelper, type: :helper do

  describe '#current_user_can_edit_need?' do
    let(:user) { build(:user) }

    subject { helper.current_user_can_edit_need?(need) }

    before(:each) {
      expect(helper).to receive(:current_user).and_return(user)
    }

    def stub_user_update_ability(response)
      expect(user).to receive(:can?).with(:update, Need).and_return(response)
    end

    context 'for a closed need' do
      let(:need) { build(:closed_need) }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'for an open need' do
      let(:need) { build(:need) }

      context 'for an user with the update ability' do
        before(:each) {
          stub_user_update_ability(true)
        }

        it 'returns true' do
          expect(subject).to be_truthy
        end
      end

      context 'for a user without the update ability' do
        before(:each) {
          stub_user_update_ability(false)
        }

        it 'returns false' do
          expect(subject).to be_falsey
        end
      end
    end
  end

end
