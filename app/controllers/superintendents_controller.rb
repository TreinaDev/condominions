class SuperintendentsController < ApplicationController
  before_action :set_condo, only: %i[new create]
  before_action :set_breadcrumbs_for_register, only: %i[new create]

  def show
    @superintendent = Superintendent.find params[:id]
    @condo = @superintendent.condo
    @tenant = @superintendent.tenant
    add_breadcrumb @condo.name.to_s, @condo
    add_breadcrumb I18n.t('breadcrumb.superintendent.show')
  end

  def new
    @superintendent = Superintendent.new(condo: @condo)
    @tenants = @condo.tenants
  end

  def create
    @superintendent = Superintendent.new(superintendent_params.merge!(condo: @condo))

    if @superintendent.save
      redirect_to @superintendent, notice: t('notices.superintendent.created')
    else
      @tenants = @condo.tenants
      flash.now[:alert] = t('alerts.superintendent.not_created')
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

  def set_breadcrumbs_for_register
    add_breadcrumb @condo.name.to_s, @condo
    add_breadcrumb I18n.t('breadcrumb.superintendent.new')
  end

end
