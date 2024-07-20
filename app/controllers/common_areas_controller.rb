class CommonAreasController < ApplicationController
  before_action :authenticate_manager!, only: %i[new edit create update]
  before_action :set_condo, only: %i[new create]
  before_action :set_common_area, only: %i[show edit update]
  before_action :set_condo_for_details, only: %i[show edit update]
  before_action -> { authorize_condo_manager(@condo) }, only: %i[new create edit update]
  before_action -> { authorize_user(@condo) }, only: [:show]
  before_action :set_breadcrumbs_for_register, only: %i[new create]
  before_action :set_breadcrumbs_for_details, only: %i[show edit update]

  def show
    @reservations = @common_area.reservations
  end

  def new
    @common_area = CommonArea.new
  end

  def edit
    add_breadcrumb I18n.t('breadcrumb.edit')
  end

  def create
    @common_area = @condo.common_areas.create(common_area_params)
    return redirect_to @common_area, notice: I18n.t('notices.common_area.created') if @common_area.save

    flash.now[:alert] = I18n.t('alerts.common_area.not_created')
    render :new, status: :unprocessable_entity
  end

  def update
    add_breadcrumb I18n.t('breadcrumb.edit')

    if @common_area.update(common_area_params)
      return redirect_to @common_area,
                         notice: I18n.t('notices.common_area.updated')
    end

    flash.now[:alert] = I18n.t('alerts.common_area.not_updated')
    render :edit, status: :unprocessable_entity
  end

  private

  def common_area_params
    params.require(:common_area).permit(:name, :description, :max_occupancy, :rules)
  end

  def set_condo_for_details
    @condo = @common_area.condo
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def set_common_area
    @common_area = CommonArea.find(params[:id])
  end

  def set_breadcrumbs_for_register
    add_breadcrumb @condo.name, condo_path(@condo)
    add_breadcrumb I18n.t('breadcrumb.common_area.new')
  end

  def set_breadcrumbs_for_details
    add_breadcrumb @common_area.condo.name, condo_path(@common_area.condo)
    add_breadcrumb @common_area.name, common_area_path(@common_area)
  end
end
