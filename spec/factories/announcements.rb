FactoryBot.define do
  factory :announcement do
    title { 'Aviso Importante' }
    message { 'Este é um aviso importante para todos os moradores' }
    manager { build :manager }
    condo { build :condo }
  end
end
