require 'rails_helper'

RSpec.describe VisitorEntry, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when params are empty' do
        visitor_entry = VisitorEntry.new

        expect(visitor_entry).not_to be_valid
        expect(visitor_entry.errors).to include :full_name
        expect(visitor_entry.errors).to include :identity_number
      end
    end

    context 'identity number size' do
      it 'greater than 4' do
        visitor_entry = VisitorEntry.new identity_number: '1234'

        expect(visitor_entry).not_to be_valid
        expect(visitor_entry.errors).to include :identity_number
      end

      it 'smaller than 11' do
        visitor_entry = VisitorEntry.new identity_number: '12345678900'

        expect(visitor_entry).not_to be_valid
        expect(visitor_entry.errors).to include :identity_number
      end
    end
  end
end
