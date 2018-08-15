class FixDefaultTypeToProfiles < ActiveRecord::Migration
  def up
    Perfil.find_each do |p|
      p.save
    end
  end

  def down
    # Impossible to know which types were null before migration
  end
end
