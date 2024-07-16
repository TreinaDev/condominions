require 'rails_helper'

RSpec.describe VisitorEntry, type: :model do
  describe '#valid?' do
    context 'presence' do
      it "fields can't be blank" do
        visitor_entry = VisitorEntry.new

        expect(visitor_entry).not_to be_valid
        expect(visitor_entry.errors).to include :full_name
        expect(visitor_entry.errors).to include :identity_number
      end
    end

    context 'identity number' do
      it 'size greater than 4' do
        visitor_entry = VisitorEntry.new identity_number: '1234'

        expect(visitor_entry).not_to be_valid
        expect(visitor_entry.errors.full_messages).to include 'RG é muito curto (mínimo: 5 caracteres)'
      end

      it 'size smaller than 11' do
        visitor_entry = VisitorEntry.new identity_number: '12345678900'

        expect(visitor_entry).not_to be_valid
        expect(visitor_entry.errors.full_messages).to include 'RG é muito longo (máximo: 10 caracteres)'
      end

      it 'only with numbers and letters' do
        visitor_entry = VisitorEntry.new identity_number: '.......'

        expect(visitor_entry).not_to be_valid
        expect(visitor_entry.errors.full_messages).to include 'RG só pode ter números e letras'
      end
    end
  end
end
