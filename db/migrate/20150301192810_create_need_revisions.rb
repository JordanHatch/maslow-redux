class CreateNeedRevisions < ActiveRecord::Migration
  def change
    create_table :need_revisions do |t|
      t.integer :need_id, null: false
      t.integer :author_id, null: false
      t.string :action_type, null: false
      t.json :snapshot
      t.timestamps
    end
  end
end
