class DesactiveSuperintendentJob < ApplicationJob
  queue_as :default

  def perform(superintendent)
    return unless superintendent.in_action? && superintendent.end_date == Date.current

    superintendent.closed!
  end
end
