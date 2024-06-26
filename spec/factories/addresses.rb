FactoryBot.define do
  factory :address do
    public_place { 'MyString' }
    number { 'MyString' }
    neighborhood { 'MyString' }
    city { 'MyString' }
    state { 'MyString' }
    zip { 'MyString' }
  end
end
