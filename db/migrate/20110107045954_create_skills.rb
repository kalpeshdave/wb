class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.references     :skillable
      t.string         :skillable_type
      t.string  :name
      t.string  :level_type
      t.timestamps
    end

    add_index :skills, :name
  end

  def self.down
    remove_index :skills, :name
    drop_table :skills
  end
end
