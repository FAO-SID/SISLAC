class SeedUserLayerIdOnHorizontes < ActiveRecord::Migration
  def up
    Horizonte.find_each do |h|
      h.update_attribute :user_layer_id, h.tipo
    end
  end

  def down
    Horizonte.update_all user_layer_id: nil
  end
end
