class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.belongs_to :team, index: true
      t.references :followable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
