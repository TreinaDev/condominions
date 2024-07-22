class Superintendent < ApplicationRecord
  belongs_to :tenant, class_name: 'Resident'
  belongs_to :condo, dependent: :destroy

  validates :start_date, :end_date, presence: true

  validate :start_date_must_be_valid, :end_date_must_be_valid

  def start_date_must_be_valid
    errors.add :start_date, 'deve ser atual ou futura' if start_date&.past?
  end

  def end_date_must_be_valid
    return unless end_date && start_date

    errors.add :end_date, 'deve ser maior que a data de ínicio' if start_date >= end_date
  end
end
