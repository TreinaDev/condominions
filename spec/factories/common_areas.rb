FactoryBot.define do
  factory :common_area do
    name { 'MyString' }
    description { 'MyText' }
    max_occupancy { 1 }
    rules { 'MyText' }
    condominium { nil }
  end
end
