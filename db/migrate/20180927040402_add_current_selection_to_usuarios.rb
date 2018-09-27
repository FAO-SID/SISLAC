class AddCurrentSelectionToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :current_selection, :integer, array: true, default: []
  end
end
