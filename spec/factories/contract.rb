Factory.define :contract do |u|
  u.sequence(:contract_number) {|n| "#{n}" }
  u.description "Contract one"
  u.long_description "This is Contract one lon description"
  u.state "England"
  u.city "Oxford"
  u.start_date Time.now
  u.end_date Time.now.advance(:days => 20)
  u.association :creator, :factory => :creator
end