class Condo < ApplicationRecord
  belongs_to :address
  has_many :towers, dependent: :destroy
  has_many :common_areas, dependent: :destroy
  has_many :unit_types, dependent: :destroy
  has_many :condo_managers, dependent: :destroy
  has_many :managers, through: :condo_managers
  has_many :announcements, dependent: :destroy
  has_many :visitors, dependent: :destroy
  has_many :visitor_entries, dependent: :destroy
  has_many :floors, through: :towers
  has_many :units, through: :floors
  has_many :owners, through: :units
  has_many :tenants, through: :units
  has_one :superintendent, dependent: :destroy

  delegate :city, to: :address
  delegate :state, to: :address

  validates :name, presence: true
  validates :registration_number, uniqueness: true
  validate :validate_cnpj

  accepts_nested_attributes_for :address

  def residents
    (tenants + owners).uniq
  end

  def filtered_residence_registration_pendings
    (tenants.residence_registration_pending + owners.residence_registration_pending).uniq
  end

  def filtered_property_registration_pendings
    (tenants.property_registration_pending + owners.property_registration_pending).uniq
  end

  def full_address
    <<~HEREDOC.strip
      #{address.public_place}, #{address.number}, #{address.neighborhood} - \
      #{address.city}/#{address.state} - CEP: #{address.zip}
    HEREDOC
  end

  def set_unit_types_fractions
    total_area = calculate_total_area
    return if total_area.zero?

    unit_types.each do |unit_type|
      fraction = (unit_type.metreage / total_area * 100).round(5)
      unit_type.update!(fraction:)
    end
  end

  def units_json
    ordered_units.map do |unit|
      {
        id: unit.id,
        floor: unit.floor.identifier,
        number: unit.short_identifier
      }
    end
  end

  def expected_visitors(date)
    visitors.where(visit_date: date)
  end

  def search_visitors_by_resident_name(resident_name)
    visitors.joins(:resident).where('residents.full_name LIKE ?', "%#{resident_name}%")
  end

  def search_visitors_by_params(key, value)
    visitors.where("#{key} LIKE ?", "%#{value}%")
  end

  def three_most_recent_announcements
    announcements.order(updated_at: :desc).limit(3)
  end

  def more_than_3_announcements
    announcements.count > 3
  end

  private

  def ordered_units
    towers.flat_map { |tower| tower.floors.flat_map(&:units) }
  end

  def calculate_total_area
    total_area = 0
    unit_types.each do |unit_type|
      total_area += unit_type.metreage * unit_type.units.count
    end

    total_area
  end

  def validate_cnpj
    if CNPJ.valid? registration_number
      cnpj_regex = %r{\A\d{2}[\.]\d{3}[\.]\d{3}[\/]\d{4}-\d{2}\z}
      unless registration_number.match cnpj_regex
        errors.add(:registration_number, 'deve estar no seguinte formato: XX.XXX.XXX/XXXX-XX')
      end
    else
      errors.add(:registration_number, 'inválido')
    end
  end
end
