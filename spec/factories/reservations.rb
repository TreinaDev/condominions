FactoryBot.define do
  factory :reservation do
    date { I18n.l(Date.current + 1.week) }
    status { 0 }
    common_area { build :common_area }
    resident { build :resident }
  end
end
