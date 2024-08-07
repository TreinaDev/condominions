class TowersController < ApplicationController
  before_action :authenticate_manager!, only: %i[show new edit_floor_units create update_floor_units]
  before_action :set_tower, only: %i[show edit_floor_units update_floor_units]
  before_action :set_condo, only: %i[new edit_floor_units create]
  before_action :set_condo_for_details, only: %i[show update_floor_units]
  before_action -> { authorize_condo_manager(@condo) }, only: %i[show new create edit_floor_units update_floor_units]
  before_action :set_breadcrumbs_for_details, only: %i[show edit_floor_units update_floor_units]
  before_action :set_breadcrumbs_for_register, only: %i[new create]

  def show; end

  def new
    @tower = Tower.new condo: @condo
  end

  def edit_floor_units
    add_breadcrumb I18n.t('breadcrumb.tower.floor_type')
    @unit_types = @condo.unit_types.order :description
  end

  def create
    @tower = Tower.new tower_params.merge! condo: @condo

    if @tower.save
      return redirect_to edit_floor_units_condo_tower_path(@tower.condo, @tower),
                         notice: t('notices.tower.created')
    end

    flash.now[:alert] = t('alerts.tower.not_created')
    render 'new', status: :unprocessable_entity
  end

  def update_floor_units
    add_breadcrumb I18n.t('breadcrumb.tower.floor_type')
    return redirect_to @tower, notice: t('notices.floor.updated') if all_unit_types_selected

    @unit_types = UnitType.order :description
    flash.now[:alert] = t('alerts.units.not_updated')
    render 'edit_floor_units', status: :unprocessable_entity
  end

  private

  def set_condo_for_details
    @condo = @tower.condo
  end

  def update_units(unit_types)
    @tower.floors.each do |floor|
      floor.units.each_with_index do |unit, index|
        unit.update unit_type_id: unit_types[index.to_s]
      end
    end

    @tower.complete!
  end

  def all_unit_types_selected
    is_all_unit_types_selected = true
    unit_types = params.require :unit_types
    unit_types.each_value { |value| is_all_unit_types_selected = false if value.blank? }

    return unless is_all_unit_types_selected

    update_units(unit_types)
    true
  end

  def set_condo
    @condo = Condo.find params[:condo_id]
  end

  def set_tower
    @tower = Tower.find params[:id]
  end

  def tower_params
    params.require(:tower).permit :name, :floor_quantity, :units_per_floor
  end

  def authenticate_manager!
    return redirect_to root_path, notice: I18n.t('alerts.tower.access_denied') if resident_signed_in?

    super
  end

  def set_breadcrumbs_for_details
    add_breadcrumb @tower.condo.name.to_s, @tower.condo
    add_breadcrumb @tower.name.to_s, @tower
  end

  def set_breadcrumbs_for_register
    add_breadcrumb @condo.name.to_s, @condo
    add_breadcrumb I18n.t('breadcrumb.tower.new')
  end
end
