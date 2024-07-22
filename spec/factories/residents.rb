FactoryBot.define do
  factory :resident do
    full_name { 'João da Silva' }
    registration_number { CPF.generate format: true }
    sequence(:email) { |n| "João#{n}@example.com" }
    password { '123456' }
    status { :mail_confirmed }

    trait :with_residence do
      transient { condo { create :condo } }

      after(:create) do |resident, evaluator|
        tower = create(:tower, condo: evaluator.condo)
        resident.residence = tower.floors[0].units[0]
      end
    end
  end
end
