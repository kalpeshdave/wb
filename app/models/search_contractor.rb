class SearchContractor < ActiveRecord::Base
  belongs_to :user

  has_many :skills, :as => :skillable, :dependent => :destroy
  accepts_nested_attributes_for :skills

  has_many :places, :as => :placable, :dependent => :destroy
  accepts_nested_attributes_for :places
  
  has_many :positions, :as => :positionable, :dependent => :destroy
  accepts_nested_attributes_for :positions

  before_save :save_skill
  before_update :save_skill
  before_save :save_place
  before_update :save_place
  before_save :save_position
  before_update :save_position


  def contracts
    @contracts ||= find_contracts
  end

  def new_skill_attributes=(skill_attributes)
     skill_attributes.each do |s|
       skills.build(s)
     end
   end

   def existing_skill_attributes=(skill_attributes)
    skills.reject(&:new_record?).each do |s|
      attributes = skill_attributes[s.id.to_s]
      if attributes
        s.attributes = attributes
      else
        skills.delete(s)
      end
    end
  end

  def save_skill
    skills.each { |s| s.save(false) }
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

   def new_position_attributes=(position_attributes)
    position_attributes.each do |p|
      positions.build(p)
    end
  end

   def existing_position_attributes=(position_attributes)
    positions.reject(&:new_record?).each do |p|
      attributes = position_attributes[p.id.to_s]
      if attributes
        p.attributes = attributes
      else
        positions.delete(p)
      end
    end
  end

   def save_position
    positions.each { |p| p.save(false) }
  end

   def self.deliver_mail_to_contractors!(emails, user)
     Notifier.deliver_mail_to_contractors(emails, user)
   end

  private

  def find_contracts
    Contract.find(:all, :conditions => conditions)
  end

  def date_from_conditions
    ["contracts.created_at >= ?", date_from] unless date_from.blank?
  end

  def date_to_conditions
    ["contracts.created_at <= ?", date_to] unless date_to.blank?
  end

  def minimum_rate_conditions
    ["contracts.rate >= ?", rate_from] unless rate_from.blank?
  end

  def maximum_rate_conditions
    ["contracts.rate <= ?", rate_to] unless rate_to.blank?
  end

  def conditions
    conditions_clauses = []
    conditions_options = []
    conditions_hash.each_pair do |key, value|
      conditions_clauses << key
      conditions_options << value
    end
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_hash.each_key.collect { |key| key }
  end

  def conditions_options
    conditions_hash.each_value.collect { |value| value }
  end

  def conditions_hash
    Hash[*conditions_parts.collect { |v|
        [v, v*2]
    }.flatten]
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
