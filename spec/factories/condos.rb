FactoryBot.define do
  factory :condo do
    name { 'Condominio Residencial Paineiras' }
    registration_number { CNPJ.generate format: true }
    address
  end
end
