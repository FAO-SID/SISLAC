class EnableExtensions < ActiveRecord::Migration
  def up
    enable_extension 'plpgsql'
    enable_extension 'postgis'
  end
  
  def down
    disable_extension 'plpgsql'
    disable_extension 'postgis'
  end
end
