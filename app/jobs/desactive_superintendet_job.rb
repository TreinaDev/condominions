class DesactiveSuperIntendentJob < ApplicationJob
  queue_as :default

  def perform(superintendent); end
end
