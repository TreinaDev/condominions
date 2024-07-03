FactoryBot.define do
  factory :manager do
    full_name { 'João Almeida' }
    registration_number { CPF.generate }
    email { 'joao@email.com' }
    password { 'password' }
  end
end
