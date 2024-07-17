class UpdateVisitDateJob < ApplicationJob
  queue_as :default

  def perform(visitor)
    return unless visitor.employee?

    @visitor = visitor
    new_visit_date = set_visit_date

    visitor.update(visit_date: new_visit_date)
    UpdateVisitDateJob.set(wait_until: (new_visit_date + 1.day).to_datetime).perform_later(visitor)
  end

  private

  def set_visit_date
    recurrence = @visitor.recurrence
    return days_recurrence(recurrence) if %w[daily working_days].include? recurrence
    return weeks_recurrence(recurrence) if %w[weekly biweekly].include? recurrence
    return months_recurrence(recurrence) if %w[monthly bimonthly quarterly semiannual].include? recurrence

    @visitor.visit_date + 1.year if recurrence == 'annual'
  end

  def days_recurrence(recurrence)
    return @visitor.visit_date + 1.day if recurrence == 'daily'

    @visitor.visit_date.next_weekday if recurrence == 'working_days'
  end

  def weeks_recurrence(recurrence)
    weeks_quantity = { 'weekly' => 1, 'biweekly' => 2 }
    @visitor.visit_date + weeks_quantity[recurrence].week
  end

  def months_recurrence(recurrence)
    months_quantity = { 'monthly' => 1, 'bimonthly' => 2, 'quarterly' => 3, 'semiannual' => 6 }
    @visitor.visit_date + months_quantity[recurrence].month
  end
end
