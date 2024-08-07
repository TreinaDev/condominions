FactoryBot.define do
  factory :tower do
    floor_quantity { 5 }
    units_per_floor { 4 }
    name { 'Torre A' }
    condo { build :condo }

    trait :with_four_units do
      transient do
        unit_types { [] }
      end

      after(:create) do |tower, evaluator|
        unit_types = evaluator.unit_types

        tower.floors.each do |floor|
          floor.units[0].update(unit_type: unit_types[0 % unit_types.size])
          floor.units[1].update(unit_type: unit_types[1 % unit_types.size])
          floor.units[2].update(unit_type: unit_types[2 % unit_types.size])
          floor.units[3].update(unit_type: unit_types[3 % unit_types.size])
        end
        tower.complete!
      end
    end
  end
end
