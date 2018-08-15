class AddUserLayerIdToHorizontes < ActiveRecord::Migration
  def change
    add_column :horizontes, :user_layer_id, :string
  end
end
