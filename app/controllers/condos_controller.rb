class CondosController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create edit update]
  before_action :set_condo, only: %i[show edit update]

  def show; end

  def new
    @condo = Condo.new
  end

  def edit; end

  def create
    @condo = Condo.new(condo_params)

    if @condo.save
      redirect_to @condo, notice: t('notices.condo.created')
    else
      flash.now[:alert] = t('alerts.condo.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @condo.update(condo_params)
      redirect_to @condo, notice: t('notices.condo.updated')
    else
      flash.now[:alert] = t('alerts.condo.not_updated')
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
