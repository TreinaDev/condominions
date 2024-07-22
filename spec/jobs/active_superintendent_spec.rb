require 'rails_helper'

RSpec.describe ActiveSuperintendentJob, type: :job do
  context 'must be activate the superintendent' do
    it 'in two days' do
      travel_to '2024-07-22'
      superintendent = create :superintendent, :pending, start_date: '2024-07-24'.to_date,
                                                         end_date: '2024-08-25'.to_date

      travel_to '2024-07-24'
      ActiveSuperintendentJob.perform_now(superintendent)
      expect(superintendent.in_action?).to eq true
    end

    it 'does not update if the accused is on another day' do
      travel_to '2024-07-22'
      superintendent = create :superintendent, :pending, start_date: '2024-07-24'.to_date,
                                                         end_date: '2024-08-25'.to_date

      travel_to '2024-07-23'
      ActiveSuperintendentJob.perform_now(superintendent)
      expect(superintendent.in_action?).to eq false
    end

    it 'and the status needs to be pending to update' do
      travel_to '2024-07-20'
      superintendent_action = create :superintendent, :in_action, start_date: '2024-07-23'.to_date,
                                                                  end_date: '2024-08-25'.to_date
      superintendent_closed = create :superintendent, :closed, start_date: '2024-07-22'.to_date,
                                                               end_date: '2024-08-23'.to_date

      travel_to '2024-07-24'
      ActiveSuperintendentJob.perform_now(superintendent_action)
      ActiveSuperintendentJob.perform_now(superintendent_closed)
      expect(superintendent_action.in_action?).to eq true
      expect(superintendent_closed.closed?).to eq true
    end
  end
end
