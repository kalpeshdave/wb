class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer     :parent_id, :attachable_id, :position
      t.string      :thumbnail, :attachable_type
      t.string      :avatar_file_name
      t.string      :avatar_content_type
      t.integer     :avatar_file_size
      t.datetime    :avatar_updated_at

      t.timestamps
    end
    add_index :attachments, :parent_id
    add_index :attachments, [:attachable_id, :attachable_type]
  end

  def self.down
    drop_table :attachments
  end
end
