class TowersController < ApplicationController
  def new
    @tower = Tower.new condo_id: params[:condo_id]
  end

  def create
    tower_params = params
      .require(:tower)
      .permit(:name, :floor_quantity, :units_per_floor)
      .merge! condo_id: params.require(:condo_id)

    @tower = Tower.new tower_params

    if @tower.save
      @tower.floor_quantity.times { Floor.create tower: @tower }
      return redirect_to @tower, notice: 'Torre cadastrada com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível cadastrar a torre.'
    render 'new', status: :unprocessable_entity
  end

  def show
    @tower = Tower.find params[:id]
  end
end
