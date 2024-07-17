class Superintendent < ApplicationRecord
  belongs_to :tenant, class_name: 'Resident'
  belongs_to :condo
end
