class TowersController < ApplicationController
  before_action :set_tower, only: %i[show edit_floor_units update_floor_units]
  before_action :authenticate_manager!, only: %i[show new edit_floor_units create update_floor_units]

  def show; end

  def new
    @tower = Tower.new condo_id: params[:condo_id]
  end

  def edit_floor_units
    @unit_types = UnitType.order :description
  end

  def create
    @tower = Tower.new tower_params.merge! condo_id: condo_id_param

    if @tower.save
      @tower.generate_floors
      return redirect_to edit_floor_units_condo_tower_path(@tower.condo, @tower),
                         notice: t('notices.tower.created')
    end

    flash.now[:alert] = t('alerts.tower.not_created')
    render 'new', status: :unprocessable_entity
  end

  def update_floor_units
    is_all_unit_types_selected = true
    unit_types = params.require :unit_types
    unit_types.each_value { |value| is_all_unit_types_selected = false if value.blank? }

    if is_all_unit_types_selected
      update_units(unit_types)
      return redirect_to @tower, notice: t('notices.floor.updated')
    end

    @unit_types = UnitType.order :description
    flash.now[:alert] = t('alerts.units.not_updated')
    render 'edit_floor_units', status: :unprocessable_entity
  end

  private

  def update_units(unit_types)
    @tower.floors.each do |floor|
      floor.units.each_with_index do |unit, index|
        unit.update unit_type_id: unit_types[index.to_s]
      end
    end
  end

  def set_tower
    @tower = Tower.find params[:id]
  end

  def tower_params
    params.require(:tower).permit :name, :floor_quantity, :units_per_floor
  end

  def condo_id_param
    params.require :condo_id
  end
end
