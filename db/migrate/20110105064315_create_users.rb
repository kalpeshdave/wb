class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :first_name,               :null => false
      t.string    :middle_name
      t.string    :last_name,               :null => false
      
      t.string    :email,               :null => false                
      t.string    :crypted_password,    :null => false                
      t.string    :password_salt,       :null => false                
      t.string    :persistence_token,   :null => false                
      t.string    :single_access_token, :null => false                
      t.string    :perishable_token,    :null => false

      t.text      :description
      t.date      :birthday
      t.boolean   :vendor
      t.string    :gender
      t.boolean   :public_profile
      t.boolean   :active
      t.integer   :secret_question_id
      t.string    :secret_answer

      t.integer   :language_id, :null => false, :default=>1
      t.integer   :payment_term_id, :null => false, :default=>1
      t.string    :date_format, :default => "DD/MM/YYYY"
      t.string    :decimal, :default => ".(Dot)"
      
      t.integer   :login_count,         :null => false, :default => 0 
      t.integer   :failed_login_count,  :null => false, :default => 0 
      t.datetime  :last_request_at                                    
      t.datetime  :current_login_at                                   
      t.datetime  :last_login_at                                      
      t.string    :current_login_ip                                   
      t.string    :last_login_ip                                      

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
