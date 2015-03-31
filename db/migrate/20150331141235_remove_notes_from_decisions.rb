class RemoveNotesFromDecisions < ActiveRecord::Migration
  def up
    remove_column :decisions, :note
  end

  def down
    add_column :decisions, :note, :text
  end
end
