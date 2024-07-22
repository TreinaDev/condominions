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

  it '#condo_presentation' do
    travel_to '2024-07-22'
    condo = create :condo, name: 'Condominio X'
    resident = create(:resident, :with_residence, condo:, full_name: 'Adroaldo')
    superintendent = create(:superintendent, :pending, tenant: resident,
                                                       condo:, start_date: '2024-07-22',
                                                       end_date: '2024-07-25')

    expect(superintendent.condo_presentation).to eq 'Adroaldo (2024-07-22 - 2024-07-25)'
  end

  describe '#after_create' do
    it 'superintendent action now' do
      travel_to '2024-07-22'
      superintendent = create :superintendent, :pending, start_date: '2024-07-22', end_date: '2024-07-25'

      expect(superintendent.in_action?).to eq true
    end

    it 'program_activate_and_desactiation' do
      travel_to '2024-07-22'
      active_superintendent_job_spy = spy 'ActiveSuperintendentJob'
      stub_const 'ActiveSuperintendentJob', active_superintendent_job_spy
      superintendent = create :superintendent, :pending, start_date: '2024-07-23', end_date: '2024-07-25'
      desactive_superintendent_job_spy = spy 'DesactiveSuperintendentJob'
      stub_const 'DesactiveSuperintendentJob', desactive_superintendent_job_spy
      create :superintendent, start_date: '2024-07-22', end_date: '2024-07-25'
 
      expect(superintendent.pending?).to eq true
      expect(active_superintendent_job_spy).to have_received(:set).with({ wait_until: '2024-07-23'.to_datetime })
      expect(desactive_superintendent_job_spy).to have_received(:set).with({ wait_until: '2024-07-25'.to_datetime })
    end
  end
end
