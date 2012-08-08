Factory.define :address do |add|
  add.association(:user)
  add.addressable_type "User"
  add.address_description "Xyz Ltd, 1st Floor"
  add.address_1 "Single Junction"
  add.address_2 "S.G Road, New Mart Road"
  add.city "Ahmedabad"
  add.zipcode "385686"
  add.state "Gujrat"
  add.country "India"
end