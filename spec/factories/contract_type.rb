Factory.define :standard_contract_type, :class => "ContractType" do |u|
  u.name "Standard"
end

Factory.define :subcontract_contract_type do |u|
  u.name "Subcontract"
end