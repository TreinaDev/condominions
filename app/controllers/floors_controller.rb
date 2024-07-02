class FloorsController < ApplicationController
  before_action :assure_floor_type_registration, only: [:show]
  before_action :authenticate_manager!, only: [:show]

  def show
    @tower = Tower.find params[:tower_id]
  end

  private

  def assure_floor_type_registration
    @floor = Floor.find params[:id]

    return if @floor.return_unit_types.present?

    redirect_to edit_floor_units_condo_tower_path(@floor.tower.condo, @floor.tower),
                alert: t('alerts.floor.not_ready')
  end
end
