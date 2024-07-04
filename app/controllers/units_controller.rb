class UnitsController < ApplicationController
  before_action :authenticate_manager!, only: [:show]
  before_action :set_tower_and_floor, only: [:show]
  before_action :set_unit, only: %i[show]

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Condomínios', :condos_path, only: %i[show]
  before_action :set_breadcrumbs_for_details, only: %i[show]

  def show; end

  private

  def set_breadcrumbs_for_details
    add_breadcrumb @tower.condo.name.to_s, condo_path(@tower.condo)
    add_breadcrumb 'Torres', condo_towers_path(@tower.condo)
    add_breadcrumb @tower.name.to_s, @tower
    add_breadcrumb @floor.print_identifier, tower_floor_path(@tower, @floor)
    add_breadcrumb @unit.print_identifier
  end

  def set_unit
    @unit = Unit.find params[:id]
  end

  def set_tower_and_floor
    @tower = Tower.find(params[:tower_id])
    @floor = Floor.find(params[:floor_id])
  end
end
