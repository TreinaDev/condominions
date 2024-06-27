class TowersController < ApplicationController
  def show
    @tower = Tower.find params[:id]
  end

  def new
    @tower = Tower.new condo_id: params[:condo_id]
  end

  def create
    @tower = Tower.new tower_params

    if @tower.save
      @tower.floor_quantity.times { Floor.create tower: @tower }
      return redirect_to @tower, notice: t('notices.tower.created')
    end

    flash.now[:alert] = t('alerts.tower.not_created')
    render 'new', status: :unprocessable_entity
  end

  private

  def tower_params
    params.require(:tower)
          .permit(:name, :floor_quantity, :units_per_floor)
          .merge! condo_id: params
          .require(:condo_id)
  end
end
