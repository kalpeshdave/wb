Factory.define :company do |s|
  s.assiciation(:user)
  s.name "xyz"
  s.url "http://google.com"
end