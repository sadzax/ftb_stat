class CreateStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :statistics do |t|
      t.references :player, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.integer :goals, default: 0
      t.integer :assists, default: 0
      t.integer :saves, default: 0
      t.integer :shots_on_target, default: 0

      t.timestamps
    end
  end
end