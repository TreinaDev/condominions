require 'rails_helper'

RSpec.describe ResidentMailer, type: :mailer do
  context '#notify_new_resident' do
    it 'send to resident email' do
      resident_joao = create :resident, full_name: 'João Carvalho', email: 'joao@email.com'

      mail = ResidentMailer.with(resident: resident_joao).notify_new_resident

      expect(mail.subject).to eq 'Confirmação de Cadastro'
      expect(mail.to).to eq ['joao@email.com']
      expect(mail.from).to eq ['registration@condo.com']
      expect(mail.body).to have_content 'João Carvalho'
      expect(mail.body).to have_content 'Email: joao@email.com'
    end
  end
end
