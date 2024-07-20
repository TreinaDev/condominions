class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show canceled]
  before_action :set_common_area, only: %i[create]
  before_action :block_manager_from_resident_sign_in, only: %i[create]
  before_action :authenticate_resident!, only: %i[create]
  before_action :authenticate_for_cancelation, only: [:canceled]
  before_action :authorize_user, only: [:show]

  def show
    @common_area = @reservation.common_area
    set_breadcrumbs
  end

  def create
    @reservation = Reservation.new date: params.require(:date),
                                   resident: current_resident,
                                   common_area: @common_area

    return redirect_to @common_area, notice: t('notices.reservation.created') if @reservation.save

    flash.now[:alert] = I18n.t 'alerts.reservation.not_created'
    render 'new', status: :unprocessable_entity
  end

  def canceled
    @reservation.canceled!
    redirect_to @reservation.common_area, notice: t('notices.reservation.canceled')
  end

  private

  def set_common_area
    @common_area = CommonArea.find params[:common_area_id]
  end

  def authenticate_resident!
    @residents = @common_area.condo.residents

    if manager_signed_in? || (resident_signed_in? && !@common_area.access_allowed?(current_resident))
      return redirect_to root_path,
                         alert: t('alerts.reservation.not_authorized')
    end

    super
  end

  def authenticate_for_cancelation
    unless resident_signed_in? || manager_signed_in?
      return redirect_to new_resident_session_path,
                         alert: t('alerts.reservation.access_denied')
    end

    return unless manager_signed_in? || (resident_signed_in? && @reservation.resident != current_resident)

    redirect_to root_path, alert: t('alerts.reservation.not_authorized')
  end

  def authorize_user
    return if !authenticate_user ||
              super_manager? ||
              condo_manager?(@reservation.common_area.condo) ||
              reservation_owner?

    redirect_to root_path, alert: t('alerts.reservation.not_authorized')
  end

  def reservation_owner?
    resident_signed_in? && @reservation.resident == current_resident
  end

  def set_reservation
    @reservation = Reservation.find params[:id]
  end

  def set_breadcrumbs
    add_breadcrumb @common_area.condo.name, @common_area.condo
    add_breadcrumb @common_area.name, @common_area
    add_breadcrumb I18n.t "breadcrumb.reservation.#{action_name}"
  end
end
