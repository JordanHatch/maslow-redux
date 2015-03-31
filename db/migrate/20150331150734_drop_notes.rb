class DropNotes < ActiveRecord::Migration
  def up
    drop_table :notes
  end

  def down
    create_table :notes do |t|
      t.integer  :need_id,     null: false
      t.integer  :author_id,   null: false
      t.integer  :revision_id
      t.string   :text
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
