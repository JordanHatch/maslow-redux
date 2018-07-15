class CreateEvidenceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :evidence_items do |t|
      t.references :evidence_type, foreign_key: true, null: false
      t.references :need, foreign_key: true, null: false
      t.text :value
      t.timestamps
    end
  end
end
