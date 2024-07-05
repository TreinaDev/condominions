class FloorsController < ApplicationController
  before_action :authenticate_manager!, only: [:show]
  before_action :assure_floor_type_registration, only: [:show]
  before_action :set_tower, only: %i[show]

  add_breadcrumb I18n.t('breadcrumb.condo.index'), :condos_path, only: %i[show]
  before_action :set_breadcrumbs_for_details, only: %i[show]

  def show; end

  private

  def set_tower
    @tower = Tower.find params[:tower_id]
  end

  def set_breadcrumbs_for_details
    add_breadcrumb @tower.condo.name.to_s, condo_path(@tower.condo)
    add_breadcrumb I18n.t('breadcrumb.tower.index'), condo_towers_path(@tower.condo)
    add_breadcrumb @tower.name.to_s, @tower
    add_breadcrumb @floor.print_identifier
  end

  def assure_floor_type_registration
    @floor = Floor.find params[:id]

    return if @floor.return_unit_types.present?

    redirect_to edit_floor_units_condo_tower_path(@floor.tower.condo, @floor.tower),
                alert: t('alerts.floor.not_ready')
  end
end
