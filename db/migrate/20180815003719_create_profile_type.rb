class CreateProfileType < ActiveRecord::Migration
  def change
    create_table :profile_types do |t|
      t.string :valor, null: false
    end
  end
end
