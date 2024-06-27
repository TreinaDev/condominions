FactoryBot.define do
  factory :condo do
    name { 'Condominio Residencial Paineiras' }
    registration_number { CNPJ.generate }
    address
  end
end
