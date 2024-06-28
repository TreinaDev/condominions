class Unit < ApplicationRecord
  belongs_to :unit_type, optional: true
  belongs_to :floor
end
