# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
#contract_types = ContractType.create([{ :name => 'Normal' }, { :name => 'Contract' }, { :name => 'SubContract' }])
languages     = Language.create([{:name => "English(default)"}, 
                                 {:name => "Spanish"},
                                 {:name => "French"},
                                 {:name => "Italian"},
                                 {:name => "Germany"}]) if Language.first.blank?
                             
payment_terms = PaymentTerm.create([{:name => "Net Month"},
                                    {:name => "Net 7"},
                                    {:name => "Net 10"},
                                    {:name => "Net 30"},
                                    {:name => "Net 60"},
                                    {:name => "Net 90"},
                                    {:name => "EOM"},
                                    {:name => "21 MFI"},
                                    {:name => "COD"}]) if PaymentTerm.first.blank?

contract_type = ContractType.create([{:name => "Standard"},
                                     {:name => "Subcontract"}]) if ContractType.first.blank?

time_base = TimeBase.create([{:name => "Day"},
                             {:name => "Week"},
                             {:name => "Month"},
                             {:name => "Year"}]) if TimeBase.first.blank?

time_unit = TimeUnit.create([{:name => '15 Min'},
                            {:name => '30 min'},
                            {:name => 'Hour'},
                            {:name => 'Day'},
                            {:name => 'Week'},
                            {:name => 'Month'}]) if TimeUnit.first.blank?

secret_question = SecretQuestion.create([{:question => "What was your mother's maiden name?"},
                                  {:question => "What was your high school name?"},
                                {:question => "What was your first pet's name?"},
                                {:question => "What is your favorite color?"}]) if SecretQuestion.first.blank?

currency = Currency.create([{:iso_name => "AED"},
                           {:iso_name => "AFN"},
                           {:iso_name => "ALL"},
                           {:iso_name => "AMD"},
                           {:iso_name => "AMD"},
                           {:iso_name => "ANG"},
                           {:iso_name => "AOA"},
                           {:iso_name => "ARS"},
                           {:iso_name => "AUD"},
                           {:iso_name => "AWG"},
                           {:iso_name => "AZN"},
                           {:iso_name => "BAM"},
                           {:iso_name => "BBD"},
                           {:iso_name => "BDT"},
                           {:iso_name => "BGN"},
                           {:iso_name => "BHD"},
                           {:iso_name => "BIF"},
                           {:iso_name => "BMD"},
                           {:iso_name => "BND"},
                           {:iso_name => "BOB"},
                           {:iso_name => "BRL"},
                           {:iso_name => "BSD"},
                           {:iso_name => "BTN"},
                           {:iso_name => "BWP"},
                           {:iso_name => "BYR"},
                           {:iso_name => "BZD"},
                           {:iso_name => "CAD"},
                           {:iso_name => "CDF"},
                           {:iso_name => "CHF"},
                           {:iso_name => "CLP"},
                           {:iso_name => "CNY"},
                           {:iso_name => "COP"},
                           {:iso_name => "CRC"},
                           {:iso_name => "CUC"},
                           {:iso_name => "CVE"},
                           {:iso_name => "CZK"},
                           {:iso_name => "DJF"},
                           {:iso_name => "DKK"},
                           {:iso_name => "DOP"},
                           {:iso_name => "DZD"},
                           {:iso_name => "EGP"},
                           {:iso_name => "ERN"},
                           {:iso_name => "ETB"},
                           {:iso_name => "EUR"},
                           {:iso_name => "FJD"},
                           {:iso_name => "FKP"},
                           {:iso_name => "GBP"},
                           {:iso_name => "GEL"},
                           {:iso_name => "GHS"},
                           {:iso_name => "GIP"},
                           {:iso_name => "GMD"},
                           {:iso_name => "GNF"},
                           {:iso_name => "GTQ"},
                           {:iso_name => "GYD"},
                           {:iso_name => "HKD"},
                           {:iso_name => "HNL"},
                           {:iso_name => "HRK"},
                           {:iso_name => "HTG"},
                           {:iso_name => "HUF"},
                           {:iso_name => "IDR"},
                           {:iso_name => "ILS"},
                           {:iso_name => "ILS"},
                           {:iso_name => "CLP"}]) if Currency.first.blank?

