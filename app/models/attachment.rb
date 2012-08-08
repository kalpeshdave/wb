class Attachment < ActiveRecord::Base
  
  belongs_to :attachable, :polymorphic => true

  has_attached_file :avatar,
#      :styles => AppConfig.photo['paperclip_options']['style'],
      :storage => AppConfig.photo['paperclip_options']['storage'],
      :path_prefix => AppConfig.photo['paperclip_options']['path_prefix']
    
  #validates_attachment_presence :avatar
  #validates_attachment_content_type :avatar, :content_type => AppConfig.photo['paperclip_options']['content_type'], :allow_nil => true
  #validates_attachment_size :avatar, :less_than => AppConfig.photo['paperclip_options']['max_size'].to_i.megabytes
end
