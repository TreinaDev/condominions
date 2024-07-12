FactoryBot.define do
  factory :visitor_entry do
    condo { build :condo }
    full_name { 'João da Silva' }
    identity_number { '33.245.654-2' }
    unit { nil }
  end
end
