class AddFinishedToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :finished, :boolean, default: false
  end
end
