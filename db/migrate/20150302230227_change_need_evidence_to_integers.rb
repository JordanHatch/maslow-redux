class ChangeNeedEvidenceToIntegers < ActiveRecord::Migration
  def change
    remove_column :needs, :yearly_user_contacts
    remove_column :needs, :yearly_site_views
    remove_column :needs, :yearly_need_views
    remove_column :needs, :yearly_searches

    add_column :needs, :yearly_user_contacts, :integer
    add_column :needs, :yearly_site_views, :integer
    add_column :needs, :yearly_need_views, :integer
    add_column :needs, :yearly_searches, :integer
  end
end
