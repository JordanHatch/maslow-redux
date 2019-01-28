class AddShowIndexPageToTagTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :tag_types, :show_index_page, :boolean, default: false
  end
end
