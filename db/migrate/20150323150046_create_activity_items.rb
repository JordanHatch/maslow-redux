class CreateActivityItems < ActiveRecord::Migration
  def change
    create_table :activity_items do |t|
      t.integer :need_id
      t.integer :user_id
      t.string :item_type
      t.json :data
      t.timestamps null: false
    end
  end
end
