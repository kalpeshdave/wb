class SearchContract < ActiveRecord::Base
  belongs_to :user

  has_many :places, :as => :placable, :dependent => :destroy
  accepts_nested_attributes_for :places

  before_save :save_place
  before_update :save_place


  def contracts
    @contracts ||= find_contracts
  end

  def new_place_attributes=(place_attributes)
    place_attributes.each do |p|
      places.build(p)
    end
  end

   def existing_place_attributes=(place_attributes)
    places.reject(&:new_record?).each do |p|
      attributes = place_attributes[p.id.to_s]
      if attributes
        p.attributes = attributes
      else
        places.delete(p)
      end
    end
  end

   def save_place
    places.each { |p| p.save(false) }
  end

   def self.deliver_mail_to_contractors!(emails, user)
     Notifier.deliver_mail_to_contractors(emails, user)
   end

  private
  
  def find_contracts
    Contract.find(:all, :conditions => conditions)
  end

  
  def date_from_conditions
    ["contracts.created_at >= ?", submitted_from] unless submitted_from.blank?
  end

  def date_to_conditions
    ["contracts.created_at <= ?", submitted_to] unless submitted_to.blank?
  end

  def minimum_rate_conditions
    ["contracts.rate >= ?", rate_from] unless rate_from.blank?
  end

  def maximum_rate_conditions
    ["contracts.rate <= ?", rate_to] unless rate_to.blank?
  end


  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
