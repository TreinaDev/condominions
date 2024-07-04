class Tower < ApplicationRecord
  belongs_to :condo
  has_many :floors, dependent: :destroy

  enum status: { incomplete: 0, complete: 5 }

  validates :name, :floor_quantity, :units_per_floor, presence: true

  validates :floor_quantity, :units_per_floor, numericality: {
    greater_than: 0, only_integer: true
  }

  def generate_floors
    floor_quantity.times { create_floor_with_units }
  end

  def warning_html_message
    "Cadastro do(a) <strong>#{name}</strong> do(a) <strong>#{condo.name}</strong> " \
      "incompleto(a), por favor, atualize o pavimento tipo.\n"
  end

  private

  def create_floor_with_units
    floor = Floor.create tower: self
    floor.generate_units
  end
end
