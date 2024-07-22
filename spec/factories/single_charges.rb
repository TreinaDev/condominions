FactoryBot.define do
  factory :single_charge do
    description { 'MyText' }
    value_cents { 1 }
    charge_type { 1 }
    condo { nil }
    unit { nil }
    common_area { nil }
  end
end
