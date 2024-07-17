FactoryBot.define do
  factory :resident do
    full_name { 'João da Silva' }
    registration_number { CPF.generate format: true }
    sequence(:email) { |n| "joao#{n}@example.com" }
    password { '123456' }
    status { :mail_confirmed }
  end
end
