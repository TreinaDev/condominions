class Resident < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :unit

  enum resident_type: { owner: 0, tenant: 1 }
  enum status: { not_confirmed: 0, confirmed: 1}
end
