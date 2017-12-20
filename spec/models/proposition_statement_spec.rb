require 'rails_helper'

RSpec.describe PropositionStatement, type: :model do

  let(:attributes) { attributes_for(:proposition_statement) }

  it 'can be created with valid attributes' do
    statement = PropositionStatement.new(attributes)

    expect(statement).to be_valid

    statement.save

    expect(statement).to be_persisted
  end

  it 'is invalid without a name' do
    statement = PropositionStatement.new(attributes.merge(name: nil))

    expect(statement).to_not be_valid
    expect(statement.errors).to have_key(:name)
  end

end
