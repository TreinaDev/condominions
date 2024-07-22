class Superintendent < ApplicationRecord
  belongs_to :tenant, class_name: 'Resident'
  belongs_to :condo, dependent: :destroy

  validates :start_date, :end_date, presence: true

  validate :start_date_must_be_valid, :end_date_must_be_valid, on: :create

  enum status: { pending: 0, in_action: 1, closed: 2 }

  after_create :action_now_or_after?
  after_create :program_deactivation

  private

  def action_now_or_after?
    return in_action! if start_date == Date.current

    ActiveSuperintendentJob.set(wait_until: start_date.to_datetime).perform_later self
  end

  def program_deactivation
    DesactiveSuperintendentJob.set(wait_until: end_date.to_datetime).perform_later self
  end

  def start_date_must_be_valid
    errors.add :start_date, 'deve ser atual ou futura' if start_date&.past?
  end

  def end_date_must_be_valid
    return unless end_date && start_date

    errors.add :end_date, 'deve ser maior que a data de ínicio' if start_date >= end_date
  end
end
