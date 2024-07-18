class SuperintendentsController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create edit update]
  before_action :set_condo, only: %i[show new create edit update]
  before_action :set_superintendent, only: %i[show edit update]
  before_action :set_breadcrumbs_condo, only: %i[new create edit update]
  before_action :set_breadcrumbs_for_register, only: %i[new create]
  before_action :set_breadcrumbs_for_edit, only: %i[edit update]
  before_action -> { authorize_condo_manager!(@condo) }, only: %i[show new create edit update]

  def show
    @tenant = @superintendent.tenant
    add_breadcrumb @condo.name.to_s, @condo
    add_breadcrumb I18n.t('breadcrumb.superintendent.show')
  end

  def new
    if @condo.superintendent
      return redirect_to condo_superintendent_path(@condo, @condo.superintendent),
                         alert: t('alerts.superintendent.exists')
    end

    @superintendent = Superintendent.new(condo: @condo)
    @tenants = @condo.tenants
  end

  def edit
    @tenants = @condo.tenants
  end

  def create
    @superintendent = Superintendent.new(superintendent_params.merge!(condo: @condo))

    unless @superintendent.save
      @tenants = @condo.tenants
      flash.now[:alert] = t('alerts.superintendent.not_created')
      return render 'new', status: :unprocessable_entity
    end

    redirect_to condo_superintendent_path(@condo, @superintendent), notice: t('notices.superintendent.created')
  end

  def update
    unless @superintendent.update(superintendent_params)
      @tenants = @condo.tenants
      flash.now[:alert] = t('alerts.superintendent.not_updated')
      return render 'new', status: :unprocessable_entity
    end

    redirect_to condo_superintendent_path(@condo, @superintendent), notice: t('notices.superintendent.updated')
  end

  private

  def authenticate_manager!
    return redirect_to root_path if resident_signed_in?

    super
  end

  def set_condo
    @condo = Condo.find params[:condo_id]
  end

  def set_superintendent
    @superintendent = Superintendent.find params[:id]
  end

  def superintendent_params
    params.require(:superintendent).permit :start_date, :end_date, :tenant_id
  end

  def set_breadcrumbs_for_register
    add_breadcrumb I18n.t('breadcrumb.superintendent.new')
  end

  def set_breadcrumbs_condo
    add_breadcrumb @condo.name.to_s, @condo
  end

  def set_breadcrumbs_for_edit
    add_breadcrumb I18n.t('breadcrumb.superintendent.edit')
  end
end
