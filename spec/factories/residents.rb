FactoryBot.define do
  factory :resident do
    full_name { 'João da Silva' }
    registration_number { CPF.generate format: true }
    sequence(:email) { |n| "joao#{n}@example.com" }
    password { '123456' }
    status { :mail_confirmed }

    trait :with_residence do
      transient { condo { create :condo } }

      after(:create) do |resident, evaluator|
        resident.residence = create(:unit, floor: create(:floor, tower: create(:tower, condo: evaluator.condo)))
      end
    end
  end
end
