FactoryBot.define do
  factory :manager do
    full_name { 'João Almeida' }
    registration_number { CPF.generate format: true }
    sequence(:email) { |n| "João#{n}@example.com" }
    password { 'password' }
    is_super { true }
  end
end
