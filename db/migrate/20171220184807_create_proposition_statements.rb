class CreatePropositionStatements < ActiveRecord::Migration[5.0]
  def change
    create_table :proposition_statements do |t|
      t.string :name, null: false
      t.string :description
      t.timestamps
    end
  end
end
