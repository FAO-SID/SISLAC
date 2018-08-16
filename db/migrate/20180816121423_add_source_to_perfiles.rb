class AddSourceToPerfiles < ActiveRecord::Migration
  def change
    add_column :perfiles, :source, :string
  end
end
