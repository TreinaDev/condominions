class TowersController < ApplicationController
  before_action :set_tower, only: %i[show edit_floor_units update_floor_units]

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
    @tower.floors.each do |floor|
      floor.units.each_with_index do |unit, index|
        unit.update!(unit_type_id: params[:unit_types][index.to_s])
      end
    end

    redirect_to @tower, notice: t('notices.floor.created')
  end

  private

  def set_tower
    @tower = Tower.find params[:id]
  end

  def tower_params
    params.require(:tower).permit(:name, :floor_quantity, :units_per_floor)
  end

  def condo_id_param
    params.require(:condo_id)
  end
end
