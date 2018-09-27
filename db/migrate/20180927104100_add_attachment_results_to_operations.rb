class AddAttachmentResultsToOperations < ActiveRecord::Migration
  def self.up
    change_table :operations do |t|
      t.attachment :results
    end
  end

  def self.down
    remove_attachment :operations, :results
  end
end
