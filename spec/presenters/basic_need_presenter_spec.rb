RSpec.describe BasicNeedPresenter do

  describe 'JSON representation' do
    it 'represents a need as JSON' do
      tag = create(:tag)
      need = create(:need, tagged_with: tag)
      presentation = BasicNeedPresenter.new(need).as_json

      expect(presentation[:id]).to eq(need.id)
      expect(presentation[:role]).to eq(need.role)
      expect(presentation[:goal]).to eq(need.goal)
      expect(presentation[:benefit]).to eq(need.benefit)
      expect(presentation[:met_when]).to eq(need.met_when)
    end
  end

end
