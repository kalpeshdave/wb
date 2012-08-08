Factory.define :phone_number do |s|
  s.name "xyz"
  s.contact_type "abc"
end

Factory.define(:phone_number_with_user) do |i|
  i.association(:user)
end
