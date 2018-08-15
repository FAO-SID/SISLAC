class AddTypeToPerfiles < ActiveRecord::Migration
  def change
    add_reference :perfiles, :type, index: true
  end
end
