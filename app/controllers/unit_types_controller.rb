class UnitTypesController < ApplicationController
  before_action :set_unit_type, only: %i[edit update show]
  before_action :set_condo
  before_action :authenticate_manager!

  def show; end

  def new
    @condo = Condo.find(params[:condo_id])
    @unit_type = UnitType.new
  end

  def edit; end

  def create
    @unit_type = UnitType.new(unit_type_params)
    if @unit_type.save
      @condo = Condo.find(params[:condo_id])
      redirect_to condo_unit_type_path(@condo, @unit_type), notice: t('notices.unit_type.created')
    else
      flash.now[:alert] = t('alerts.unit_type.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @unit_type.update(unit_type_params)
      redirect_to condo_unit_type_path(@condo, @unit_type), notice: t('notices.unit_type.updated')
    else
      flash.now[:alert] = t('alerts.unit_type.not_updated')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_unit_type
    @unit_type = UnitType.find(params[:id])
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def unit_type_params
    params.require(:unit_type).permit(:description, :metreage, :fraction)
  end
end
