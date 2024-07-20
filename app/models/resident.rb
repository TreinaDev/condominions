class Resident < ApplicationRecord
  has_one :residence, class_name: 'Unit', foreign_key: 'tenant_id', dependent: :nullify, inverse_of: :tenant
  has_many :properties, class_name: 'Unit', foreign_key: 'owner_id', dependent: :nullify, inverse_of: :owner
  has_many :reservations, dependent: :destroy
  has_many :visitors, dependent: :destroy

  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  validate :valid_registration_number
  validates :full_name, presence: true
  validates :registration_number, uniqueness: true

  has_one_attached :user_image

  enum status: { property_registration_pending: 0, residence_registration_pending: 1, mail_not_confirmed: 2,
                 mail_confirmed: 3 }

  def condos
    units = properties.any? ? properties.clone : []
    units << residence if residence
    units.map(&:condo).uniq
  end

  def todays_visitors
    visitors.where(visit_date: Date.current)
  end

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
