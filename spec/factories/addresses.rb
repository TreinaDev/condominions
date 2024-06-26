FactoryBot.define do
  factory :address do
    public_place { 'Travessa João Edimar' }
    number { '29' }
    neighborhood { 'João Eduardo II' }
    city { 'Rio Branco' }
    state { 'AC' }
    zip { '69911520' }
  end
end
