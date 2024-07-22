require 'rails_helper'

RSpec.describe DesactiveSuperintendentJob, type: :job do
  context 'must be activate the superintendent' do
    it 'in two days' do
      travel_to '2024-07-22'.to_date
      superintendent = create :superintendent, :in_action, start_date: '2024-07-22'.to_date,
                                                           end_date: '2024-07-24'.to_date

      travel_to '2024-07-24'.to_date
      DesactiveSuperintendentJob.perform_now(superintendent)
      expect(superintendent.closed?).to eq true
    end

    it 'does not update if the accused is on another day' do
      travel_to '2024-07-22'.to_date
      superintendent = create :superintendent, :in_action, start_date: '2024-07-22'.to_date,
                                                           end_date: '2024-07-24'.to_date

      travel_to '2024-07-23'.to_date
      DesactiveSuperintendentJob.perform_now(superintendent)
      expect(superintendent.closed?).to eq false
    end

    it 'and the status needs to be in_action to update' do
      travel_to '2024-07-20'.to_date
      superintendent_action = create :superintendent, :pending, start_date: '2024-07-23'.to_date,
                                                                end_date: '2024-07-24'.to_date
      superintendent_closed = create :superintendent, :closed, start_date: '2024-07-22'.to_date,
                                                               end_date: '2024-07-24'.to_date

      travel_to '2024-07-24'.to_date
      DesactiveSuperintendentJob.perform_now(superintendent_action)
      DesactiveSuperintendentJob.perform_now(superintendent_closed)
      expect(superintendent_action.pending?).to eq true
      expect(superintendent_closed.closed?).to eq true
    end
  end
end
