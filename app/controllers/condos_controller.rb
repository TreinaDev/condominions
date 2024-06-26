class CondosController < ApplicationController
  def show
    @condo = Condo.find(params[:id])
  end

  def new
    @condo = Condo.new
  end

  def edit
    @condo = Condo.find(params[:id])
  end

  def create
    @condo = Condo.new(condo_params)

    if @condo.save
      flash.alert = 'Cadastrado com sucesso!'
      redirect_to @condo
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @condo = Condo.find(params[:id])

    if @condo.update(condo_params)
      flash.alert = 'Editado com sucesso!'
      redirect_to @condo
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def condo_params
    params.require(:condo).permit(:name, :registration_number,
                                  address_attributes: [:public_place, :number,
                                                       :neighborhood, :city,
                                                       :state, :zip])
  end
end
