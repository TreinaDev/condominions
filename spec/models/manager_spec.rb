require 'rails_helper'

RSpec.describe Manager, type: :model do
  describe '#description' do
    it 'displays the full name and email' do
      manager = Manager.new(email: 'admin@email.com', full_name: 'João Carvalho')

      expect(manager.description).to eq 'João Carvalho - admin@email.com'
    end
  end

  describe '#valid?' do
    it 'missing params' do
      manager = Manager.new(full_name: '', registration_number: '')

      manager.valid?
      expect(manager.errors).to include(:full_name)
      expect(manager.errors).to include(:registration_number)
    end

    it 'registration number must be unique' do
      unique_registration_number = CPF.generate
      create(:manager, registration_number: unique_registration_number)
      manager = Manager.new(registration_number: unique_registration_number)

      manager.valid?
      expect(manager.errors).to include(:registration_number)
    end

    it 'registration number must be valid' do
      manager = Manager.new(registration_number: '012.345.678-10')
      manager.valid?

      expect(manager.errors).to include(:registration_number)
    end

    it 'registration number must be formatted with dashes and dots' do
      manager = Manager.new(registration_number: '48151872071')
      manager.valid?
      expect(manager.errors).not_to include(:registration_number)
      expect(manager.registration_number).to eq '481.518.720-71'
    end
  end
end
