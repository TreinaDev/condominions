require 'rails_helper'

RSpec.describe ResidentMailer, type: :mailer do
  context '#notify_new_resident' do
    it 'send to resident email' do
      condo = create :condo, name: 'Condominio Certo'
      tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 2, units_per_floor: 4
      tower.generate_floors
      first_floor = tower.floors[0]
      third_unit = first_floor.units[2]
      resident_joao = create :resident, full_name: 'João Carvalho',
                                        email: 'joao@email.com'

      mail = ResidentMailer.with(resident: resident_joao).notify_new_resident

      expect(mail.subject).to eq 'Confirmação de Cadastro'
      expect(mail.to).to eq ['joao@email.com']
      expect(mail.from).to eq ['registration@condo.com']
      expect(mail.body).to have_content 'João Carvalho'
      expect(mail.body).to have_content 'Email: joao@email.com'
    end
  end
end
