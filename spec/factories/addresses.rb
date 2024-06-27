FactoryBot.define do
  factory :address do
    public_place { 'Rua dos Rubis' }
    number { '120' }
    neighborhood { 'Jardim dos Rubis' }
    city { 'Xique-Xique' }
    state { 'BA' }
    zip { '42800000' }
  end
end
