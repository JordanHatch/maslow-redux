require 'rails_helper'

RSpec.describe NeedCollectionPresenter do

  let(:needs) { create_list(:need, 3, goal: "do a thing") }
  subject { NeedCollectionPresenter.new(needs) }

  describe '#as_collection' do
    it 'presents needs as a collection for select boxes' do
      expected = [
        [ "##{needs[0].id}: Do a thing", needs[0].id],
        [ "##{needs[1].id}: Do a thing", needs[1].id],
        [ "##{needs[2].id}: Do a thing", needs[2].id],
      ]

      expect(subject.as_collection).to contain_exactly(*expected)
    end
  end

end
