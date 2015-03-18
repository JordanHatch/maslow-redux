class DropNeedStatuses < ActiveRecord::Migration
  def up
    drop_table :need_statuses
  end

  def down
    create_table "need_statuses" do |t|
      t.integer "need_id", null: false
      t.text    "description"
      t.text    "reasons", default: [], array: true
      t.text    "additional_comments"
      t.text    "validation_conditions"
    end
  end
end
