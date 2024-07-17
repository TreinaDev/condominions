FactoryBot.define do
  factory :visitor do
    full_name { 'João da silva' }
    identity_number { '313131' }
    category { :visitor }
    visit_date { 1.month.from_now.to_date }
    resident { create :resident }
    condo { resident.condo }
  end
end
