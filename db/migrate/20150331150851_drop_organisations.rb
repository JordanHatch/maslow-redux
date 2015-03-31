class DropOrganisations < ActiveRecord::Migration
  def up
    drop_table :organisations
  end

  def down
    create_table :organisations do |t|
      t.string :name,         null: false
      t.string :abbreviation
    end
  end
end
