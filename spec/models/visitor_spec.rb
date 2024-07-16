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
      end
    end
  end
end
