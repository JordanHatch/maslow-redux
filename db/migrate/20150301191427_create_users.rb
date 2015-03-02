class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.text :permissions, array: true, default: []
      t.text :bookmarks, array: true, default: []
    end
  end
end
