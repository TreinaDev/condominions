class UnitsController < ApplicationController
  before_action :authenticate_manager!, only: [:show]

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Condomínios', :condos_path, only: %i[show]

  def show
    @unit = Unit.find params[:id]
    @tower = @unit.floor.tower
    add_breadcrumb @tower.condo.name.to_s, condo_path(@tower.condo)
    add_breadcrumb 'Torres', condo_towers_path(@tower.condo)
    add_breadcrumb @tower.name.to_s, @tower
    add_breadcrumb @unit.floor.print_identifier, tower_floor_path(@tower, @unit.floor)
    add_breadcrumb @unit.print_identifier
  end
end
