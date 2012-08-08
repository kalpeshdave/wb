Factory.define :user do |u|
  u.first_name "sharon"
  u.last_name "smith"
  u.email "sharon@example.com"
  u.password "secret"
  u.password_confirmation "secret"
  u.active true
  u.association :language, :factory => :language
  u.association :payment_term, :factory => :payment_term
#  u.skills {|skills| [skills.association(:skill)]}
end

Factory.define(:user_with_skills, :parent => :user) do |u|
  u.after_create do |o|
    o.skills = [Factory.build(:skill, :user => o), Factory.build(:skill, :user => o)]
  end
end

Factory.define(:user_with_phone_numbers, :parent => :user) do |u|
  u.after_create do |o|
    o.phone_numbers = [Factory.build(:phone_number, :user => o), Factory.build(:phone_number, :user => o)]
  end
end
