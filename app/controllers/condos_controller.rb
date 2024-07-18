class CondosController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create edit update residents]
  before_action :set_condo, only: %i[show edit update add_manager associate_manager residents]
  before_action :set_breadcrumbs_for_details, only: %i[show edit update add_manager associate_manager]
  before_action :authorize_super_manager!, only: %i[new create add_manager associate_manager]
  before_action -> { authorize_condo_manager!(@condo) }, only: %i[show edit update residents]

  def show
    @residents = @condo.residents
    @towers = @condo.towers.order :name
    @common_areas = @condo.common_areas.order :name
    @unit_types = @condo.unit_types.order :description
    @todays_visitors = (resident_signed_in? ? current_resident.todays_visitors : @condo.expected_visitors(Time.zone.today))
  end

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

    unless @condo.save
      flash.now[:alert] = t('alerts.condo.not_created')
      return render :new, status: :unprocessable_entity
    end

    redirect_to @condo, notice: t('notices.condo.created')
  end

  def update
    add_breadcrumb I18n.t('breadcrumb.edit')

    unless @condo.update(condo_params)
      flash.now[:alert] = t('alerts.condo.not_updated')
      return render :edit, status: :unprocessable_entity
    end

    redirect_to @condo, notice: t('notices.condo.updated')
  end

  def add_manager
    add_breadcrumb I18n.t('breadcrumb.condo.new_manager')
    @managers = Manager.where(is_super: false).where.not(id: @condo.managers.pluck(:id)).order(:full_name)
  end

  def associate_manager
    @manager = Manager.find(params[:manager_id])
    return redirect_to @condo, notice: I18n.t('notices.condo.manager_associated') if @condo.managers << @manager

    redirect_to @condo, alert: I18n.t('notices.condo.manager_not_associated')
  end

  def residents
    return render status: :ok, json: @condo.residents.as_json(only: %i[id full_name]) if @condo

    render status: :not_found, json: []
  end

  private

  def authenticate_manager!
    return redirect_to root_path if resident_signed_in?

    super
  end

  def set_breadcrumbs_for_details
    add_breadcrumb @condo.name.to_s, condo_path(@condo)
  end

  def condo_params
    params.require(:condo).permit(:name, :registration_number,
                                  address_attributes: %i[public_place number neighborhood city state zip])
  end

  def set_condo
    @condo = Condo.find_by(id: params[:id])
  end
end
