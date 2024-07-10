class Resident < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # delegate :floor, to: :unit, allow_nil: true
  # delegate :tower, to: :floor, allow_nil: true
  # delegate :condo, to: :tower, allow_nil: true
  belongs_to :residence, class_name: 'Unit', dependent: :destroy, optional: true

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  validate :valid_registration_number
  validates :full_name, presence: true
  validates :registration_number, uniqueness: true

  has_one_attached :user_image

  enum status: { not_tenant: 0, not_owner: 1, mail_not_confirmed: 2, mail_confirmed: 3 }

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

  def photo_warning_html_message
    return if user_image.attached? || not_confirmed?

    "Por favor, <a href='#{Rails.application.routes.url_helpers.edit_photo_resident_path(self)}'>cadastre sua foto</a>"
  end

  private

  def valid_registration_number
    return errors.add(:registration_number, 'inválido') unless CPF.valid? registration_number

    return if registration_number.match CPF_REGEX

    errors.add(:registration_number, 'deve estar no seguinte formato: XXX.XXX.XXX-XX')
  end
end
