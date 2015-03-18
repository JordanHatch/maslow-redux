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

end
