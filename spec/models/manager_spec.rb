require 'rails_helper'

RSpec.describe Manager, type: :model do
  describe '#description' do
    it 'Exibe o nome completo e o email' do
      manager = Manager.new(email: 'admin@email.com', full_name: 'João Carvalho')

      expect(manager.description).to eq 'João Carvalho - admin@email.com'
    end
  end

  describe '#valid' do
    it 'nome completo é obrigatório' do
      manager = Manager.new(full_name: '')

      manager.valid?
      expect(manager.errors.include?(:full_name)).to be true
    end

    it 'CPF é obrigatório' do
      manager = Manager.new(registration_number: '')

      manager.valid?
      expect(manager.errors.include?(:registration_number)).to be true
    end

    it 'CPF deve ser único' do
      unique_registration_number = CPF.generate
      Manager.create!(registration_number: unique_registration_number, full_name: 'João Almeida',
                      email: 'joão@emai.com', password: 'password')
      manager = Manager.new(registration_number: unique_registration_number)

      manager.valid?
      expect(manager.errors.include?(:registration_number)).to be true
    end
  end

  describe 'Validação CPF' do
    it 'CPF deve ser válido' do
      manager = Manager.new(registration_number: '012.345.678-10')
      manager.valid?

      expect(manager.errors.include?(:registration_number)).to be true
    end

    it 'CPF deve ser formatado com traços e pontos' do
      manager = Manager.new(registration_number: '48151872071')
      manager.valid?
      expect(manager.errors.include?(:registration_number)).to be false
      expect(manager.registration_number).to eq '481.518.720-71'
    end
  end
end
