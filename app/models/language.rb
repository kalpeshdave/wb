class Language < ActiveRecord::Base
  NAMES = find(:all, :order => :name).map do |t|
    [t.name, t.id]
  end
  has_many :users
end
