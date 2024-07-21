FactoryBot.define do
  factory :superintendent do
    condo { build :condo }
    tenant { create(:resident, :with_residence, condo:) }
    start_date { Time.zone.today }
    end_date { Time.zone.today >> 6 }
  end
end
