FactoryBot.define do
  factory :condo do
    name { 'Condomínio dos Rubis' }
    registration_number { '82909116000102' }
    address { build :address }
  end
end
