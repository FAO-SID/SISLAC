class AddUuidToPerfiles < ActiveRecord::Migration
  def change
    add_column :perfiles, :uuid, :string
  end
end
