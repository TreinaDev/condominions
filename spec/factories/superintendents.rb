FactoryBot.define do
  factory :superintendent do
    tenant { build :resident }
    condo { build :condo }
    start_date { Time.zone.today }
    end_date { Time.zone.today >> 6 }
  end
end
