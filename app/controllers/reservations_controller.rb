class ReservationsController < ApplicationController
  before_action :block_manager_from_resident_sign_in, only: %i[new create]
  before_action :authenticate_resident!, only: %i[new create]
  before_action :set_common_area, only: %i[new create]
  before_action :set_breadcrumbs_for_register, only: [:new]

  def show
    @reservation = Reservation.find params[:id]
    @common_area = @reservation.common_area
    set_breadcrumbs_for_details
  end

  def new
    @reservation = Reservation.new common_area: @common_area
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.resident = current_resident
    @reservation.common_area = @common_area

    return redirect_to @reservation, notice: t('notices.reservation.created') if @reservation.save

    flash.now[:alert] = t('alerts.reservation.not_created')
    render 'new', status: :unprocessable_entity
  end

  private

  def reservation_params
    params.require(:reservation).permit(:date)
  end

  def set_common_area
    @common_area = CommonArea.find params[:common_area_id]
  end

  def authenticate_resident!
    return redirect_to root_path, alert: I18n.t('alerts.reservation.access_denied') if manager_signed_in?

    super
  end

  def set_breadcrumbs_for_details
    add_breadcrumb @common_area.condo.name, @common_area.condo
    add_breadcrumb @common_area.name, @common_area
    add_breadcrumb I18n.t('breadcrumb.reservation.show')
  end

  def set_breadcrumbs_for_register
    add_breadcrumb @common_area.condo.name, @common_area.condo
    add_breadcrumb @common_area.name, @common_area
    add_breadcrumb I18n.t('breadcrumb.reservation.new')
  end
end
