class AddOrderedNeedsToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :priority_need_ids, :integer, array: true, default: []
  end
end
