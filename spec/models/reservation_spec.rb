require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '#valid' do
    it 'date must be present' do
      reservation = build :reservation, date: nil

      expect(reservation).not_to be_valid
      expect(reservation.errors).to include :date
    end
  end
end
