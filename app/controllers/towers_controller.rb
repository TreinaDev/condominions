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

    if @tower.save!
      @tower.floor_quantity.times do
        floor = Floor.create tower: @tower
      end

      return redirect_to @tower, notice: 'Torre cadastrada com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível cadastrar a torre.'
    render 'new'
  end

  def show
    @tower = Tower.find params[:id]
  end
end
