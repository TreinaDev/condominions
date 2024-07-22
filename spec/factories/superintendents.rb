FactoryBot.define do
  factory :superintendent do
    condo { build :condo }
    tenant { create(:resident, :with_residence, condo:) }
    start_date { Date.current }
    end_date { Date.current >> 6 }
  end
end
