class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.references :usuario, index: true, foreign_key: true
      t.integer :profile_ids, array: true, default: []

      t.timestamps null: false
    end
  end
end
