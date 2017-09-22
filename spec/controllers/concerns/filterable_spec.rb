require 'rails_helper'

RSpec.describe Concerns::Filterable, :type => :controller do
  controller(ApplicationController) do
    include Concerns::Filterable

    skip_authorization_check

    def index
      @needs = filtered_needs.all
      head 200
    end
  end

  describe '#filtered_needs' do
    let!(:tag) { create(:tag) }
    let!(:needs) { create_list(:need, 5) }

    it 'returns a list of all needs' do
      get :index

      expect(assigns(:needs)).to contain_exactly(*needs)
    end

    it 'returns needs tagged with a single tag' do
      tagged_needs = create_list(:need, 2, tagged_with: tag)

      get :index, params: { tag.tag_type.identifier => tag.id }

      expect(assigns(:needs)).to contain_exactly(*tagged_needs)
    end

    it 'returns needs tagged with multiple tags of different types' do
      tag_1 = create(:tag)
      tag_2 = create(:tag)

      tagged_needs = create_list(:need, 2, tagged_with: [tag_1, tag_2])

      get :index, params: {
                    tag_1.tag_type.identifier => tag_1.id,
                    tag_2.tag_type.identifier => tag_2.id,
                  }

      expect(assigns(:needs)).to contain_exactly(*tagged_needs)
    end
  end

  describe '#active_filters' do
    it 'returns the current active tag filters' do
      tags = create_list(:tag, 5)
      needs = create_list(:need, 5)

      tag = tags.first

      need = create(:need, tagged_with: tag)

      get :index, params: {
        tag.tag_type.identifier => tag.id
      }

      expected = {
        tag.tag_type.identifier => [tag]
      }

      expect(controller.active_filters).to eq(expected)
    end
  end

  describe '#available_filters' do
    it 'returns a list of tags grouped by type' do
      tag_type = create(:tag_type)
      tags = create_list(:tag, 5, tag_type: tag_type)

      get :index

      expect(controller.available_filters).to eq({ tag_type => tags })
    end
  end

end
