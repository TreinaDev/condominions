class Visitor < ApplicationRecord
  belongs_to :resident
  enum category: { visitor: 0, employee: 1 }

  enum recurrence: { once: 0, daily: 1, working_days: 2, weekly: 3, biweekly: 4,
                     monthly: 5, bimonthly: 6, quarterly: 7, semiannual: 8, annual: 9 }

  validates :visit_date, :full_name, :identity_number, presence: true
end
