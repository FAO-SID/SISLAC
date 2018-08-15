class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :acronym, null: false
      t.string :statement, null: false
    end
  end
end
