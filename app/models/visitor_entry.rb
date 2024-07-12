class VisitorEntry < ApplicationRecord
  belongs_to :condo
  belongs_to :unit, optional: true

  validates :full_name, :identity_number, presence: true
  validates :identity_number, length: { in: 5..10 }
end
