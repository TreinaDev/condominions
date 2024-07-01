FactoryBot.define do
  factory :unit do
    floor { build :floor }
    unit_type { nil }
  end
end
