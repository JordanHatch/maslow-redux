class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :need_id, null: false
      t.integer :author_id, null: false
      t.integer :revision_id
      t.string :text
      t.timestamps
    end
  end
end
