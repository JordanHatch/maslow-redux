class DropDecisions < ActiveRecord::Migration[5.2]
  def up
    drop_table :decisions 
  end

  def down
    create_table "decisions", id: :serial, force: :cascade do |t|
      t.integer "need_id", null: false
      t.string "decision_type", null: false
      t.string "outcome", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
