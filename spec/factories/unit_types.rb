FactoryBot.define do
  factory :unit_type do
    description { 'Apartamento de 1 quarto' }
    metreage { 50.55 }
    fraction { nil }
    condo { build :condo }
  end
end
