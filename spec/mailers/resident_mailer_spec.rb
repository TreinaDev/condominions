require 'rails_helper'

RSpec.describe ResidentMailer, type: :mailer do
  context '#notify_new_resident' do
    it 'send to resident email' do
      condo = create :condo, name: 'Condominio Certo'
      tower = create :tower, 'condo' => condo, name: 'Torre correta', floor_quantity: 8, units_per_floor: 4
      first_floor = tower.floors[0]
      third_unit = first_floor.units[2]
      resident_joao = create :resident, full_name: 'João Carvalho', resident_type: :owner,
                                        email: 'joao@email.com', unit: third_unit

      mail = ResidentMailer.with(resident: resident_joao).notify_new_resident

      expect(mail.subject).to eq 'Confirmação de Cadastro'
      expect(mail.to).to eq ['joao@email.com']
      expect(mail.from).to eq ['registration@condo.com']
      expect(mail.body).to have_content 'João Carvalho'
      expect(mail.body).to have_content 'Tipo de Usuário: Proprietário'
      expect(mail.body).to have_content 'Email: joao@email.com'
      expect(mail.body).to have_content 'Condomínio: Condominio Certo'
      expect(mail.body).to have_content 'Torre: Torre correta'
      expect(mail.body).to have_content 'Andar: 1'
      expect(mail.body).to have_content 'Identificação: Unidade 13'
    end
  end
end
