class CreateUserAccessLists < ActiveRecord::Migration
  def self.up
    create_table :user_access_lists do |t|
      t.integer :user_id
      t.integer :access_user_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :user_access_lists
  end
end
