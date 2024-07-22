require 'rails_helper'

RSpec.describe Resident, type: :model do
  describe '#valid?' do
    it 'missing params' do
      resident = Resident.new full_name: '', registration_number: ''

      expect(resident).not_to be_valid
      expect(resident.errors).to include :full_name
      expect(resident.errors).to include :registration_number
    end

    it 'registration number must be unique' do
      unique_registration_number = CPF.generate format: true
      create :resident, registration_number: unique_registration_number
      resident = build :resident, registration_number: unique_registration_number

      expect(resident).not_to be_valid
      expect(resident.errors).to include :registration_number
    end

    it 'registration number must be valid' do
      resident = build :resident, registration_number: '012.345.678-10'

      expect(resident).not_to be_valid
      expect(resident.errors).to include :registration_number
    end

    it 'registration number must be formatted' do
      resident = build :resident, registration_number: '48151872071'

      expect(resident).not_to be_valid
      expect(resident.errors).to include :registration_number
      expect(resident.errors.full_messages).to include 'CPF deve estar no seguinte formato: XXX.XXX.XXX-XX'
    end

    it 'receipt must be valid' do
      resident = build :resident, :with_residence
      resident.receipt.attach(io: File.open('spec/support/images/test_image.txt'),
                              filename: 'test_image.txt')

      expect(resident).not_to be_valid
      expect(resident.errors).to include :receipt
      expect(resident.errors.full_messages).to include 'Comprovante deve ser um PDF, JPEG, JPG, ou PNG'
    end
  end
end
