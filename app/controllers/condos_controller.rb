class CondosController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create edit update]
  before_action :set_condo, only: %i[show edit update]

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Condomínios', :condos_path, only: %i[show edit]

  def index
    @condos = Condo.all
  end

  def show
    add_breadcrumb @condo.name.to_s, condo_path(@condo)
  end

  def new
    add_breadcrumb 'Cadastrar'
    @condo = Condo.new
  end

  def edit
    add_breadcrumb @condo.name.to_s, condo_path(@condo)
    add_breadcrumb 'Editar'
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
                                  address_attributes: %i[public_place number neighborhood city state zip])
  end

  def set_condo
    @condo = Condo.find(params[:id])
  end
end
