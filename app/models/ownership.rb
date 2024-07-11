class Ownership < ApplicationRecord
  validates :resident_id, uniqueness: { scope: :unit_id, message: I18n.t('error.ownership.not_unique') }
  belongs_to :unit
  belongs_to :resident
end
