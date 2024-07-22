class VisitorEntry < ApplicationRecord
  ID_REGEX = /\A[a-zA-Z0-9]+\z/

  belongs_to :condo
  belongs_to :unit, optional: true

  validates :full_name, :identity_number, presence: true
  validates :identity_number, length: { in: 5..10 }
  validates :identity_number,
            format: { with: ID_REGEX, message: I18n.t('alerts.visitor_entry.only_numbers_and_letters') }

  before_save :set_database_datetime

  private

  def set_database_datetime
    self.database_datetime ||= (DateTime.now + Time.zone.utc_offset.seconds)
  end
end
