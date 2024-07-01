FactoryBot.define do
  factory :tower do
    floor_quantity { 5 }
    units_per_floor { 4 }
    name { 'Torre A' }
    condo { build :condo }
  end
end
