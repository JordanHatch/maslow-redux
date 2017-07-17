class CreateNeedResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :need_responses do |t|
      t.references :need, null: false
      t.string :response_type, null: false
      t.string :name, null: false
      t.string :url
      t.timestamps
    end
  end
end
