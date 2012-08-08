class SecretQuestion < ActiveRecord::Base
  NAMES = find(:all, :order => :question).map do |t|
    [t.question, t.id]
  end
  has_many :users
end
