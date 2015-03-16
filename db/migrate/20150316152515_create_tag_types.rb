class CreateTagTypes < ActiveRecord::Migration
  def change
    create_table :tag_types do |t|
      t.string :identifier, null: false
      t.string :name,       null: false
      t.timestamps
    end
  end
end
