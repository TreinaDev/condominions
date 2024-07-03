FactoryBot.define do
  factory :floor do
    tower { build :tower }
  end
end
