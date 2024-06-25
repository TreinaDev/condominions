class UnitTypesController < ApplicationController
  def new
    @unit_type = UnitType.new
  end

  def create
    @unit_type = UnitType.new(receive_params)
    if @unit_type.save
      redirect_to @unit_type, notice: t('notices.unit_type.created')
    else
      flash.now[:alert] = t('alerts.unit_type.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @unit_type = UnitType.find(params[:id])
  end

  private

  def receive_params
    params.require(:unit_type).permit(:description, :metreage)
  end
end
