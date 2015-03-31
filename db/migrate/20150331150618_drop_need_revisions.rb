class DropNeedRevisions < ActiveRecord::Migration
  def up
    drop_table :need_revisions
  end

  def down
    create_table :need_revisions do |t|
      t.integer  :need_id,     null: false
      t.integer  :author_id,   null: false
      t.string   :action_type, null: false
      t.json     :snapshot
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
