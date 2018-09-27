class AddNameToOperation < ActiveRecord::Migration
  def change
    add_column :operations, :name, :string, null: false
  end
end
