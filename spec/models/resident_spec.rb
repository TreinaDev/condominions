require 'rails_helper'

RSpec.describe Resident, type: :model do
  describe '#valid?' do
    it 'missing params' do
      resident = Resident.new(full_name: '', registration_number: '', resident_type: '')

      resident.valid?
      expect(resident.errors).to include(:full_name)
      expect(resident.errors).to include(:registration_number)
      expect(resident.errors).to include(:resident_type)
    end

    it 'registration number must be unique' do
      unique_registration_number = CPF.generate(format: true)
      create(:resident, registration_number: unique_registration_number)
      resident = build(:resident, registration_number: unique_registration_number)

      resident.valid?
      expect(resident.errors).to include(:registration_number)
    end

    it 'registration number must be valid' do
      resident = build(:resident, registration_number: '012.345.678-10')
      resident.valid?

      expect(resident.errors).to include(:registration_number)
    end

    it 'registration number must be formatted' do
      resident = build(:resident, registration_number: '48151872071')
      resident.valid?
      expect(resident.errors).to include(:registration_number)
      expect(resident.errors.full_messages).to include('CPF deve estar no seguinte formato: XXX.XXX.XXX-XX')
    end
  end
end
