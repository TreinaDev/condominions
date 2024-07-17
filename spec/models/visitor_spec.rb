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
  end
end
