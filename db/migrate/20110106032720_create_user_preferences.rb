class CreateUserPreferences < ActiveRecord::Migration
  def self.up
    create_table :user_preferences do |t|
      t.integer :user_id
      t.boolean :contact_me, :default => true
      t.timestamps
    end

    add_index :user_preferences, :user_id
  end

  def self.down
    drop_table :user_preferences
  end
end
