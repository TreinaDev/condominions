class UpdateVisitDateJob < ApplicationJob
  queue_as :default

  def perform(visitor)
    return unless visitor.employee?

    new_visit_date = visitor.next_recurrent_date

    return if new_visit_date.nil?

    visitor.update(visit_date: new_visit_date)
    UpdateVisitDateJob.set(wait_until: (new_visit_date + 1.day).to_datetime).perform_later(visitor)
  end
end
