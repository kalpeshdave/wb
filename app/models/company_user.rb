class CompanyUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_many :companies
  has_many :users
end
