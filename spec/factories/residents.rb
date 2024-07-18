FactoryBot.define do
  factory :resident do
    full_name { 'João da Silva' }
    registration_number { CPF.generate format: true }
    sequence(:email) { |n| "João#{n}@example.com" }
    password { '123456' }
    status { :mail_confirmed }

    trait :with_residence do
      transient do
        condo { create :condo }
        unit { nil }
      end

      after(:create) do |resident, evaluator|
        unit = evaluator.unit || create(:unit, floor: create(:floor, tower: create(:tower, condo: evaluator.condo)))
        resident.properties << unit
        resident.update residence: unit
      end
    end
  end
end
