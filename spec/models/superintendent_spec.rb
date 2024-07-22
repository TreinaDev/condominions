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

  describe '#after_create' do
    it 'superintendent action now' do
      travel_to '2024-07-22'.to_date
      superintendent = create :superintendent, :pending, start_date: '2024-07-22', end_date: '2024-07-25'

      expect(superintendent.in_action?).to eq true
    end

    it 'program active superintendent' do
      travel_to '2024-07-22'.to_date
      active_superintendent_job_spy = spy 'ActiveSuperintendentJob'
      stub_const 'ActiveSuperintendentJob', active_superintendent_job_spy
      superintendent = create :superintendent, :pending, start_date: '2024-07-23', end_date: '2024-07-25'

      expect(superintendent.pending?).to eq true
      expect(active_superintendent_job_spy).to have_received(:set).with({ wait_until: '2024-07-23'.to_datetime })
    end

    it 'program desactive superintendent' do
      travel_to '2024-07-22'.to_date
      desactive_superintendent_job_spy = spy 'DesactiveSuperintendentJob'
      stub_const 'DesactiveSuperintendentJob', desactive_superintendent_job_spy
      create :superintendent, start_date: '2024-07-22', end_date: '2024-07-25'

      expect(desactive_superintendent_job_spy).to have_received(:set).with({ wait_until: '2024-07-25'.to_datetime })
    end
  end
end
