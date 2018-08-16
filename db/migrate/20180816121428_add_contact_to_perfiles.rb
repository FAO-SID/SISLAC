class AddContactToPerfiles < ActiveRecord::Migration
  def change
    add_column :perfiles, :contact, :string
  end
end
