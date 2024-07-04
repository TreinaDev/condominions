class Resident < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  validate :valid_registration_number
  validates :registration_number, uniqueness: true
  belongs_to :unit

  after_create :send_invitation

  enum resident_type: { owner: 0, tenant: 1 }
  enum status: { not_confirmed: 0, confirmed: 1 }

  def condo
    unit.floor.tower.condo
  end

  def tower
    unit.floor.tower
  end

  def floor_print_identifier
    unit.floor.print_identifier
  end

  private

  def send_invitation
    ResidentMailer.with(resident: self).notify_new_resident.deliver
  end

  def valid_registration_number
    if CPF.valid? registration_number
      unless registration_number.match(/\A\d{3}[\.]\d{3}[\.]\d{3}[\-]\d{2}\z/)
        errors.add(:registration_number, 'deve estar no seguinte formato: XXX.XXX.XXX-XX')
      end
    else
      errors.add(:registration_number, 'inválido')
    end
  end
end
