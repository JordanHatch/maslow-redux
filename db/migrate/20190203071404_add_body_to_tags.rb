class AddBodyToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :body, :text
  end
end
