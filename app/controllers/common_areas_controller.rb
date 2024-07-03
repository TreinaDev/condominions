class CommonAreasController < ApplicationController
  before_action :authenticate_manager!, only: %i[new edit create update]
  before_action :set_condo, only: %i[new create]
  before_action :set_common_area, only: %i[show edit update]

  def show
    redirect_to(root_path, notice: t('alerts.common_area.not_allowed')) unless manager_signed_in?
  end

  def new
    @common_area = CommonArea.new
  end

  def edit; end

  def create
    @common_area = @condo.common_areas.create(common_area_params)
    if @common_area.save
      redirect_to @common_area, notice: t('notices.common_area.created')
    else
      flash[:alert] = t('alerts.common_area.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @common_area.update(common_area_params)
      redirect_to @common_area, notice: t('notices.common_area.updated')
    else
      flash[:alert] = t('alerts.common_area.not_updated')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def set_common_area
    @common_area = CommonArea.find(params[:id])
  end

  def common_area_params
    params.require(:common_area).permit(:name, :description, :max_occupancy, :rules)
  end
end
