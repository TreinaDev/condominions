require 'rails_helper'

RSpec.describe SingleCharge, type: :model do
  describe '#valid' do
    it 'missing params' do
      single_charge = SingleCharge.new charge_type: nil, condo: nil,
                                       unit: nil, description: nil, value_cents: nil

      expect(single_charge).not_to be_valid
      expect(single_charge.errors).to include :charge_type
      expect(single_charge.errors).to include :condo
      expect(single_charge.errors).to include :unit
      expect(single_charge.errors).not_to include :description
      expect(single_charge.errors).to include :value_cents
    end

    it 'description required, case charge_type is fine' do
      single_charge = SingleCharge.new charge_type: :fine, description: nil

      expect(single_charge).not_to be_valid
      expect(single_charge.errors).to include :description
    end

    it 'unit needs an owner' do
      unit = create :unit
      single_charge = SingleCharge.new(unit:)

      expect(single_charge).not_to be_valid
      expect(single_charge.errors.full_messages).to include 'Unidade não possui um proprietário.'
    end
  end
end
