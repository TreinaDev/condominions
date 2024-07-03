FactoryBot.define do
  factory :unit_type do
    description { 'Apartamento de 1 quarto' }
    metreage { 50.55 }
    fraction { 3 }
    condo { build :condo }
  end
end
