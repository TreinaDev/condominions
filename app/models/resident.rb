class Resident < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  belongs_to :unit
  delegate :floor, to: :unit, allow_nil: true
  delegate :tower, to: :floor, allow_nil: true
  delegate :condo, to: :tower, allow_nil: true

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  validate :valid_registration_number
  validates :full_name, :resident_type, presence: true
  validates :registration_number, uniqueness: true

  has_one_attached :user_image

  enum resident_type: { owner: 0, tenant: 1 }
  enum status: { not_confirmed: 0, confirmed: 1 }

  def description
    "#{full_name} - #{email}"
  end

  def send_invitation(random_password)
    ResidentMailer.with(resident: self, password: random_password).notify_new_resident.deliver
  end

  def password_same_as_current?(password)
    return false unless valid_password?(password)

    errors.add :password, 'deve ser diferente da atual'
    true
  end

  def password_confirmation_invalid?(password, password_confirmation)
    return false unless password != password_confirmation

    errors.add :password_confirmation, 'deve ser igual a senha'
    true
  end

  private

  def valid_registration_number
    return errors.add(:registration_number, 'inválido') unless CPF.valid? registration_number

    return if registration_number.match CPF_REGEX

    errors.add(:registration_number, 'deve estar no seguinte formato: XXX.XXX.XXX-XX')
  end
end
