class UnitsController < ApplicationController
  before_action :authenticate_manager!, only: %i[show find_units]
  before_action :set_tower_and_floor, only: %i[show]
  before_action :set_unit, only: %i[show]

  before_action :set_breadcrumbs_for_details, only: %i[show]

  def show; end

  def find_units
    tower = Tower.find_by(id: params[:id])
    return render status: :not_found, json: { units: [] } unless tower

    units = tower.units
    return render status: :not_found, json: { units: [] } if units.empty?

    render json: units.to_json(only: [:id], methods: [:short_identifier])
  end

  private

  def set_breadcrumbs_for_details
    add_breadcrumb @tower.condo.name.to_s, condo_path(@tower.condo)
    set_breadcrumb_for_tower
    add_breadcrumb @floor.print_identifier, tower_floor_path(@tower, @floor)
    add_breadcrumb @unit.print_identifier
  end

  def set_breadcrumb_for_tower
    add_breadcrumb I18n.t('breadcrumb.tower.index'), condo_towers_path(@tower.condo)
    add_breadcrumb @tower.name.to_s, @tower
  end

  def set_unit
    @unit = Unit.find params[:id]
  end

  def set_tower_and_floor
    @tower = Tower.find(params[:tower_id])
    @floor = Floor.find(params[:floor_id])
  end
end
