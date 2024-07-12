class CondosController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create edit update]
  before_action :set_condo, only: %i[show edit update add_manager associate_manager]
  before_action :set_breadcrumbs_for_details, only: %i[show edit update add_manager associate_manager]

  def show; end

  def new
    add_breadcrumb I18n.t('breadcrumb.condo.new')
    @condo = Condo.new
  end

  def edit
    add_breadcrumb I18n.t('breadcrumb.edit')
  end

  def create
    add_breadcrumb I18n.t('breadcrumb.condo.new')
    @condo = Condo.new(condo_params)

    if @condo.save
      redirect_to @condo, notice: t('notices.condo.created')
    else
      flash.now[:alert] = t('alerts.condo.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    add_breadcrumb I18n.t('breadcrumb.edit')
    if @condo.update(condo_params)
      redirect_to @condo, notice: t('notices.condo.updated')
    else
      flash.now[:alert] = t('alerts.condo.not_updated')
      render :edit, status: :unprocessable_entity
    end
  end

  def add_manager
    add_breadcrumb I18n.t('breadcrumb.condo.new_manager')
    @managers = Manager.where(is_super: false).where.not(id: @condo.managers.pluck(:id)).order(:full_name)
  end

  def associate_manager
    @manager = Manager.find(params[:manager_id])
    if @condo.managers << @manager
      redirect_to @condo, notice: I18n.t('notices.condo.manager_associated')
    else
      redirect_to @condo, alert: I18n.t('notices.condo.manager_not_associated')
    end
  end

  private

  def set_breadcrumbs_for_details
    add_breadcrumb @condo.name.to_s, condo_path(@condo)
  end

  def condo_params
    params.require(:condo).permit(:name, :registration_number,
                                  address_attributes: %i[public_place number neighborhood city state zip])
  end

  def set_condo
    @condo = Condo.find(params[:id])
  end
end
