class CreateNeedStatuses < ActiveRecord::Migration
  def change
    create_table :need_statuses do |t|
      t.integer :need_id, null: false
      t.text :description
      t.text :reasons, array: true, default: []
      t.text :additional_comments
      t.text :validation_conditions
    end
  end
end
