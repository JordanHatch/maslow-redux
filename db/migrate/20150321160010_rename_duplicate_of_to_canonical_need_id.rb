class RenameDuplicateOfToCanonicalNeedId < ActiveRecord::Migration
  def change
    rename_column :needs, :duplicate_of, :canonical_need_id
  end
end
