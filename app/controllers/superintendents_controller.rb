class SuperintendentsController < ApplicationController
  before_action :set_condo, only: %i[new create]

  def show
    @superintendent = Superintendent.find params[:id]
  end

  def new
    @superintendet = Superintendent.new(condo: @condo)
    @tenants = @condo.tenants
  end

  def create
    @superintendent = Superintendent.new(superintendent_params.merge!(condo: @condo))

    if @superintendent.save!
      redirect_to @superintendent, notice: t('notices.superintendent.created')
    else
      flash.now[:alert] = t('alerts.superintendent.not_updated')
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def set_condo
    @condo = Condo.find params[:condo_id]
  end

  def superintendent_params
    params.require(:superintendent).permit :start_date, :end_date, :tenant_id
  end
end
