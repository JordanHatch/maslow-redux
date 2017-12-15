class CreateNeedPerformancePoints < ActiveRecord::Migration[5.0]
  def change
    create_table :need_performance_points do |t|
      t.references :need_response, null: false
      t.date :date, null: false
      t.string :metric_type, null: false
      t.decimal :value
      t.timestamps
    end
  end
end
