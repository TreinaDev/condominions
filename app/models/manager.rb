class Manager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  validate :valid_registration_number
  validates :full_name, :registration_number, presence: true
  validates :registration_number, uniqueness: true

  has_one_attached :user_image

  def description
    "#{full_name} - #{email}"
  end

  private

  def valid_registration_number
    if CPF.valid?(registration_number, strict: true)
      self.registration_number = CPF.new(registration_number).formatted
    else
      errors.add :registration_number, 'deve ser válido'
    end
  end
end
