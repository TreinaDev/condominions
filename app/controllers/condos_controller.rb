class CondosController < ApplicationController

  def show 
    @condo = Condo.find(params[:id])
  end

  def new
    @condo = Condo.new
  end

  def create
    @condo = Condo.new(condo_params)
    
    if @condo.save
      flash.alert = "Cadastrado com sucesso!"
      redirect_to @condo
    else
      render 'new'
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