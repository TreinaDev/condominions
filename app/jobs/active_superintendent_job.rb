class ActiveSuperintendentJob < ApplicationJob
  queue_as :default

  def perform(superintendent)
    return unless superintendent.pending? && superintendent.start_date == Date.current

    superintendent.in_action!
  end
end
