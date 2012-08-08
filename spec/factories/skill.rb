Factory.define :skill do |s|
  s.name "xyz"
  s.type "abc"
end

Factory.define(:skill_with_user) do |i|
  i.association(:user)
end
