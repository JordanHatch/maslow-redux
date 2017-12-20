class CreateJoinTableNeedPropositionStatement < ActiveRecord::Migration[5.0]
  def change
    create_join_table :needs, :proposition_statements do |t|
      t.index [:need_id, :proposition_statement_id], name: :index_need_statements
      t.index [:proposition_statement_id, :need_id], name: :index_statement_needs
    end
  end
end
