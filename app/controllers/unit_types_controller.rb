class UnitTypesController < ApplicationController
  before_action :set_unit_type, only: %i[edit update show]
  before_action :set_condo, only: %i[new create]
  before_action :authenticate_manager!

  before_action :set_breadcrumb_for_details, only: %i[show edit update]
  before_action :set_breadcrumb_for_register, only: %i[new create]

  def index; end

  def show; end

  def new
    @unit_type = UnitType.new
  end

  def edit
    add_breadcrumb I18n.t('breadcrumb.edit')
  end

  def create
    @unit_type = UnitType.new(unit_type_params)
    @unit_type.condo = @condo

    if @unit_type.save
      redirect_to @unit_type, notice: t('notices.unit_type.created')
    else
      flash.now[:alert] = t('alerts.unit_type.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    add_breadcrumb I18n.t('breadcrumb.edit')
    if @unit_type.update(unit_type_params)
      redirect_to @unit_type, notice: t('notices.unit_type.updated')
    else
      flash.now[:alert] = t('alerts.unit_type.not_updated')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_unit_type
    @unit_type = UnitType.find(params[:id])
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def unit_type_params
    params.require(:unit_type).permit(:description, :metreage, :fraction)
  end

  def set_breadcrumb_for_details
    @condo = @unit_type.condo
    add_breadcrumb @condo.name, @condo
    add_breadcrumb I18n.t('breadcrumb.unit_type.index'), condo_unit_types_path(@condo)
    add_breadcrumb @unit_type.description, @unit_type
  end

  def set_breadcrumb_for_register
    add_breadcrumb @condo.name, @condo
    add_breadcrumb I18n.t('breadcrumb.unit_type.new')
  end

  def authenticate_manager!
    return redirect_to root_path, notice: I18n.t('alerts.unit_type.access_denied') if resident_signed_in?

    super
  end
end
