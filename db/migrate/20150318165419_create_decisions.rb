class CreateDecisions < ActiveRecord::Migration
  def change
    create_table :decisions do |t|
      t.integer :need_id, null: false
      t.string :decision_type, null: false
      t.string :outcome, null: false
      t.text :note
      t.timestamps null: false
    end
  end
end
