class Resident < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # delegate :floor, to: :unit, allow_nil: true
  # delegate :tower, to: :floor, allow_nil: true
  # delegate :condo, to: :tower, allow_nil: true
  belongs_to :residence, class_name: 'Unit', dependent: :destroy, optional: true
  has_many :ownerships, dependent: :destroy
  has_many :units, through: :ownerships, dependent: :destroy

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  validate :valid_registration_number
  validates :full_name, presence: true
  validates :registration_number, uniqueness: true

  has_one_attached :user_image

  enum status: { not_owner: 0, not_tenant: 1, mail_not_confirmed: 2, mail_confirmed: 3 }

  def description
    "#{full_name} - #{email}"
  end

  def send_invitation(random_password)
    ResidentMailer.with(resident: self, password: random_password).notify_new_resident.deliver
  end

  def photo_warning_html_message
    return if user_image.attached? || mail_not_confirmed?

    "Por favor, <a href='#{Rails.application.routes.url_helpers.edit_photo_resident_path(self)}'>cadastre sua foto</a>"
  end

  def warning_html_message_tenant
    "Cadastro de <strong>#{full_name}</strong> " \
      "incompleto, por favor, indique a sua residência ou se não reside no condomínio.\n"
  end

  def warning_html_message_owner
    "Cadastro de <strong>#{full_name}</strong> " \
      "incompleto, por favor, adicione unidades possuídas, caso haja, ou finalize o cadastro.\n"
  end

  private

  def valid_registration_number
    return errors.add(:registration_number, 'inválido') unless CPF.valid? registration_number

    return if registration_number.match CPF_REGEX

    errors.add(:registration_number, 'deve estar no seguinte formato: XXX.XXX.XXX-XX')
  end
end
