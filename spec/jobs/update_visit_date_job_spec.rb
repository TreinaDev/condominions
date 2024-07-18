require 'rails_helper'

RSpec.describe UpdateVisitDateJob, type: :job do
  context 'should update the visit date' do
    it 'with daily recurrence' do
      resident = create(:resident, :with_residence)
      first_visitor = create :visitor,  resident:,
                             full_name: 'João Ferreira',
                             visit_date: 1.day.from_now,
                             category: :employee, recurrence: :daily

      travel_to 2.days.from_now do
        UpdateVisitDateJob.perform_now(first_visitor)
        expect(first_visitor.visit_date).to eq Date.current
        expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 1.day).to_datetime)
      end
    end

    it 'with weekly recurrence' do
      resident = create(:resident, :with_residence)
      first_visitor = create :visitor, resident:,
                             full_name: 'João Ferreira',
                             visit_date: 1.day.from_now,
                             category: :employee, recurrence: :weekly

      travel_to 2.days.from_now do
        UpdateVisitDateJob.perform_now(first_visitor)
        expect(first_visitor.visit_date).to eq 6.days.from_now.to_date
        expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 1.week).to_datetime)
      end
    end

    it 'with biweekly recurrence' do
      resident = create(:resident, :with_residence)
      first_visitor = create :visitor, resident:,
                             full_name: 'João Ferreira',
                             visit_date: 1.day.from_now,
                             category: :employee, recurrence: :biweekly

      travel_to 2.days.from_now do
        UpdateVisitDateJob.perform_now(first_visitor)
        expect(first_visitor.visit_date).to eq 13.days.from_now.to_date
        expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 2.weeks).to_datetime)
      end
    end

    it 'with monthly recurrence' do
      resident = create(:resident, :with_residence)
      first_visitor = create :visitor, resident:,
                             full_name: 'João Ferreira',
                             visit_date: 1.day.from_now,
                             category: :employee, recurrence: :monthly

      travel_to 2.days.from_now do
        UpdateVisitDateJob.perform_now(first_visitor)
        expect(first_visitor.visit_date).to eq (1.month.from_now - 1.day).to_date
        expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 1.month).to_datetime)
      end
    end

    it 'with bimonthly recurrence' do
      resident = create(:resident, :with_residence)
      first_visitor = create :visitor, resident:,
                             full_name: 'João Ferreira',
                             visit_date: 1.day.from_now,
                             category: :employee, recurrence: :bimonthly

      travel_to 2.days.from_now do
        UpdateVisitDateJob.perform_now(first_visitor)
        expect(first_visitor.visit_date).to eq (2.months.from_now - 1.day).to_date
        expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 2.months).to_datetime)
      end
    end

    it 'with quarterly recurrence' do
      resident = create(:resident, :with_residence)
      first_visitor = create :visitor, resident:,
                             full_name: 'João Ferreira',
                             visit_date: 1.day.from_now,
                             category: :employee, recurrence: :quarterly

      travel_to 2.days.from_now do
        UpdateVisitDateJob.perform_now(first_visitor)
        expect(first_visitor.visit_date).to eq (3.months.from_now - 1.day).to_date
        expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 3.months).to_datetime)
      end
    end

    it 'with semiannual recurrence' do
      resident = create(:resident, :with_residence)
      first_visitor = create :visitor, resident:,
                             full_name: 'João Ferreira',
                             visit_date: 1.day.from_now,
                             category: :employee, recurrence: :semiannual

      travel_to 2.days.from_now do
        UpdateVisitDateJob.perform_now(first_visitor)
        first_visitor.reload
        expect(first_visitor.visit_date).to eq (6.months.from_now - 1.day).to_date
        expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 6.months).to_datetime)
      end
    end

    it 'annual recurrence' do
      resident = create(:resident, :with_residence)
      first_visitor = create :visitor, resident:,
                             full_name: 'João Ferreira',
                             visit_date: 1.day.from_now,
                             category: :employee, recurrence: :annual

      travel_to 2.days.from_now do
        UpdateVisitDateJob.perform_now(first_visitor)
        expect(first_visitor.visit_date).to eq (1.year.from_now - 1.day).to_date
        expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 1.year).to_datetime)
      end
    end

    context 'working days' do
      it 'week daily recurrence' do
        visit_day = Time.zone.now.next_week(:monday)
        resident = create(:resident, :with_residence)
        first_visitor = create :visitor, resident:,
                               full_name: 'João Ferreira',
                               visit_date: visit_day,
                               category: :employee, recurrence: :working_days

        travel_to(visit_day + 1.day) do
          UpdateVisitDateJob.perform_now(first_visitor)
          expect(first_visitor.visit_date).to eq Date.current
          expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 1.day).to_datetime)
        end
      end

      it 'friday recurrence' do
        visit_day = Time.zone.now.next_week(:friday)
        resident = create(:resident, :with_residence)
        first_visitor = create :visitor, resident:,
                               full_name: 'João Ferreira',
                               visit_date: visit_day,
                               category: :employee, recurrence: :working_days

        travel_to(visit_day + 1.day) do
          UpdateVisitDateJob.perform_now(first_visitor)
          first_visitor.reload
          expect(first_visitor.visit_date).to eq(Date.current + 2.days)
          expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 3.days).to_datetime)
        end
      end

      it 'saturday recurrence' do
        visit_day = Time.zone.today.next_occurring(:saturday)
        resident = create(:resident, :with_residence)
        first_visitor = create :visitor, resident:,
                               full_name: 'João Ferreira',
                               visit_date: visit_day,
                               category: :employee, recurrence: :working_days

        travel_to(visit_day + 1.day) do
          UpdateVisitDateJob.perform_now(first_visitor)
          expect(first_visitor.visit_date).to eq(Date.current + 1.day)
          expect(UpdateVisitDateJob).to have_been_enqueued.with(first_visitor).at((Date.current + 2.days).to_datetime)
        end
      end
    end
  end
end
