class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  validate :valid_registration_number
  validates :full_name, :registration_number, presence: true
  validates :registration_number, uniqueness: true

  has_many :condo_managers, dependent: :destroy
  has_many :condos, through: :condo_managers

  has_one_attached :user_image

  def description
    "#{full_name} - #{email}"
  end

  private

  def valid_registration_number
    if CPF.valid? registration_number
      unless registration_number.match CPF_REGEX
        errors.add(:registration_number, 'deve estar no seguinte formato: XXX.XXX.XXX-XX')
      end
    else
      errors.add(:registration_number, 'inválido')
    end
  end
end
