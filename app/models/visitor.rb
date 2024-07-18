class Visitor < ApplicationRecord
  ID_REGEX = /\A[a-zA-Z0-9]+\z/

  belongs_to :resident
  belongs_to :condo
  enum category: { visitor: 0, employee: 1 }

  enum recurrence: { once: 0, daily: 1, working_days: 2, weekly: 3, biweekly: 4,
                     monthly: 5, bimonthly: 6, quarterly: 7, semiannual: 8, annual: 9 }

  validates :visit_date, :full_name, :identity_number, :category, presence: true
  validate :date_is_future, on: :create
  validates :recurrence, presence: true, if: -> { employee? }
  validates :recurrence, absence: true, if: -> { visitor? }
  validates :identity_number, length: { in: 5..10 }
  validates :identity_number,
            format: { with: ID_REGEX, message: I18n.t('alerts.visitor.only_numbers_and_letters') }

  def next_recurrent_date
    return if once? || recurrence.nil?

    set_recurrence_date
  end

  private

  def date_is_future
    return unless visit_date.present? && visit_date < Time.zone.today

    errors.add(:visit_date, 'deve ser futura.')
  end

  def set_recurrence_date
    return days_recurrence if %w[daily working_days].include? recurrence
    return weeks_recurrence if %w[weekly biweekly].include? recurrence
    return months_recurrence if %w[monthly bimonthly quarterly semiannual].include? recurrence

    visit_date + 1.year if annual?
  end

  def days_recurrence
    return visit_date + 1.day if daily?

    visit_date.next_weekday if working_days?
  end

  def weeks_recurrence
    weeks_quantity = { 'weekly' => 1, 'biweekly' => 2 }
    visit_date + weeks_quantity[recurrence].week
  end

  def months_recurrence
    months_quantity = { 'monthly' => 1, 'bimonthly' => 2, 'quarterly' => 3, 'semiannual' => 6 }
    visit_date + months_quantity[recurrence].month
  end
end
