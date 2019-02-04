require 'rails_helper'

RSpec.describe Team, type: :model do

  describe '.new' do
    let(:attributes) { attributes_for(:team).slice(:name, :description) }
    let(:team) { described_class.new(attributes) }

    context 'with valid attributes' do
      it 'is valid' do
        expect(team).to be_valid
      end

      it 'is persisted on save' do
        team.save
        expect(team).to be_persisted
      end
    end

    context 'with an empty name' do
      let(:attributes) { attributes_for(:team).slice(:description) }

      it 'is invalid' do
        expect(team).to_not be_valid
        expect(team.errors).to have_key(:name)
      end

      it 'is not persisted on save' do
        team.save
        expect(team).to_not be_persisted
      end
    end
  end

  describe '#users' do
    let(:users) { create_list(:user, 3) }
    let(:team) { create(:team, users: users) }

    it 'returns users' do
      expect(team.users).to contain_exactly(*users)
    end
  end

end
