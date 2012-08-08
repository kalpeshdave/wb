class CreateSearchContracts < ActiveRecord::Migration
  def self.up
    create_table :search_contracts do |t|
      t.integer :user_id
      t.date    :submitted_from
      t.date    :submitted_to
      t.decimal :rate_from, :precision => 10, :scale => 2
      t.decimal :rate_to, :precision => 10, :scale => 2
      
      t.timestamps
    end
  end

  def self.down
    drop_table :search_contracts
  end
end
