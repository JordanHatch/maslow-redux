class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.string :role, null: false
      t.string :goal, null: false
      t.string :benefit, null: false
      t.text :met_when, array: true, default: []
      t.string :yearly_user_contacts
      t.string :yearly_site_views
      t.string :yearly_need_views
      t.integer :yearly_searches
      t.string :other_evidence
      t.string :legislation
      t.integer :duplicate_of
    end
  end
end
