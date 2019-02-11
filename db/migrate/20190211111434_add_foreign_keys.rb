class AddForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key "activity_items", "needs"
    add_foreign_key "activity_items", "users"

    add_foreign_key "taggings", "needs"
    add_foreign_key "taggings", "tags"

    add_foreign_key "tags", "tag_types"
  end
end
