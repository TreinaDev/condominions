FactoryBot.define do
  factory :resident do
    full_name { 'João da Silva' }
    registration_number { CPF.generate format: true }
    sequence(:email) { |n| "joao#{n}@example.com" }
    password { '123456' }
    status { :mail_confirmed }

    trait :with_residence do
      transient do
        tower { create(:tower) }
      end

      after(:create) do |resident, evaluator|
        tower = evaluator.tower
        resident.residence = tower.floors[0].units[0]
      end
    end
  end
end
