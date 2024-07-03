FactoryBot.define do
  factory :resident do
    full_name { 'João da Silva' }
    registration_number { CPF.generate format: true }
    email { 'joao@email.com' }
    password { '123456' }
    resident_type { :owner }
    unit
    status { 0 }
  end
end
