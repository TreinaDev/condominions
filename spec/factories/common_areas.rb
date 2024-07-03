FactoryBot.define do
  factory :common_area do
    name { 'Salão de Festas' }
    description { 'Realize sua festa em nosso salão de festas' }
    max_occupancy { 100 }
    rules { 'Salão de festas não pode ser utilizado após as 22 horas' }
    condo { build :condo }
  end
end
