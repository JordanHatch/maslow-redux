require 'rails_helper'

RSpec.describe ActivityItemsHelper, type: :helper do

  describe '#format_changed_fields_list' do
    it 'joins each field name into a friendly sentence' do
      output = format_changed_fields_list(['one', 'two', 'three'])

      expect(output).to eq('<span>One</span>, <span>Two</span>, and <span>Three</span>')
    end

    it 'does not insert the word "and" when only one item is present' do
      output = format_changed_fields_list(['one'])

      expect(output).to eq('<span>One</span>')
    end

    it 'does not a comma when only two items are present' do
      output = format_changed_fields_list(['one', 'two'])

      expect(output).to eq('<span>One</span> and <span>Two</span>')
    end
  end

end
