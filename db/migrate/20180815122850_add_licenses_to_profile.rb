class AddLicensesToProfile < ActiveRecord::Migration
  def change
    add_reference :perfiles, :license, index: true, foreign_key: true
  end
end
