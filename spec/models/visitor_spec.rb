require 'rails_helper'

RSpec.describe Visitor, type: :model do
  describe '#valid?' do
    context 'presence' do
      it "fields can't be blank" do
        visitor = Visitor.new

        expect(visitor).not_to be_valid
        expect(visitor.errors).to include :full_name
        expect(visitor.errors).to include :identity_number
        expect(visitor.errors).to include :visit_date
        expect(visitor.errors).to include :category
      end

      it "recurrence must be present if it's an employee" do
        visitor = Visitor.new(category: :employee, recurrence: '')

        expect(visitor).not_to be_valid
        expect(visitor.errors).to include :recurrence
      end

      it "recurrence cannot be present if it's a visitor" do
        visitor = Visitor.new(category: :visitor, recurrence: :weekly)

        expect(visitor).not_to be_valid
        expect(visitor.errors).to include :recurrence
      end
    end

    context 'identity number' do
      it 'size greater than 4' do
        visitor = Visitor.new identity_number: '1234'

        expect(visitor).not_to be_valid
        expect(visitor.errors.full_messages).to include 'RG é muito curto (mínimo: 5 caracteres)'
      end

      it 'size smaller than 11' do
        visitor = Visitor.new identity_number: '12345678900'

        expect(visitor).not_to be_valid
        expect(visitor.errors.full_messages).to include 'RG é muito longo (máximo: 10 caracteres)'
      end

      it 'only with numbers and letters' do
        visitor = Visitor.new identity_number: '.......'

        expect(visitor).not_to be_valid
        expect(visitor.errors.full_messages).to include 'RG só pode ter números e letras'
      end
    end

    context 'visit date' do
      it 'must be in the future' do
        visitor = Visitor.new visit_date: 2.days.ago

        expect(visitor).not_to be_valid
        expect(visitor.errors.full_messages).to include 'Data da Visita deve ser futura.'
      end
    end
  end
end
