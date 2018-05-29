class AddCountryToPerfiles < ActiveRecord::Migration
  def change
    add_column :perfiles, :country, :string
  end
end
