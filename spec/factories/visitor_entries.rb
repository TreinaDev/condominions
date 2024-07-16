FactoryBot.define do
  factory :visitor_entry do
    condo { build :condo }
    full_name { 'João da Silva' }
    identity_number { '332456542' }
    unit { nil }
  end
end
