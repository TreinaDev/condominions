require 'rails_helper'

RSpec.describe Superintendent, type: :model do
  describe '#valid?' do
    it 'missing params' do
      superintendent = build :superintendent, start_date: nil, end_date: nil, tenant: nil, condo: nil

      expect(superintendent).not_to be_valid
      expect(superintendent.errors).to include :start_date
      expect(superintendent.errors).to include :end_date
      expect(superintendent.errors).to include :tenant
      expect(superintendent.errors).to include :condo
    end

    it 'start date greater than or equal to today' do
      superintendent = build :superintendent, start_date: Date.yesterday

      expect(superintendent).not_to be_valid
      expect(superintendent.errors).to include :start_date
    end

    it 'end date greater than to start_date' do
      superintendent = build :superintendent, start_date: Date.current, end_date: Date.current

      expect(superintendent).not_to be_valid
      expect(superintendent.errors).to include :end_date
    end
  end
end
