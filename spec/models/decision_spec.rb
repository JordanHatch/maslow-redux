require 'rails_helper'

RSpec.describe Decision, :type => :model do

  let(:need) { create(:need) }

  it 'can be created with valid attributes' do
    decision = Decision.new(need: need, decision_type: 'scope', outcome: 'in_scope')
    expect(decision).to be_valid

    decision.save
    expect(decision).to be_persisted
  end

  it 'is invalid with an unknown decision type' do
    decision = Decision.new(need: need, decision_type: 'foo')

    expect(decision).to_not be_valid
    expect(decision.errors).to have_key(:decision_type)
  end

  it 'is invalid with an unknown outcome for the decision type' do
    decision = Decision.new(need: need, decision_type: 'scope', outcome: 'foo')

    expect(decision).to_not be_valid
    expect(decision.errors).to have_key(:outcome)
  end

  describe '.of_type' do
    it 'returns decisions only of the given type' do
      expected = create_list(:scope_decision, 3)
      create_list(:completion_decision, 5)

      expect(Decision.of_type(:scope)).to contain_exactly(*expected)
    end
  end

  describe '.latest' do
    it 'can return the latest decision for a given type' do
      create_list(:scope_decision, 5)
      latest_decision = create(:scope_decision)

      expect(Decision.latest(:scope)).to eq(latest_decision)
    end

    it 'returns nil if no decisions exist' do
      expect(Decision.latest(:scope)).to be_nil
    end
  end

end
