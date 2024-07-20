class ReservationsController < ApplicationController
  before_action :set_common_area, only: %i[create canceled]
  before_action :set_reservation, only: :canceled
  before_action :block_manager_from_resident_sign_in, only: :create
  before_action :authenticate_resident!, only: :create
  before_action :authenticate_for_cancelation, only: :canceled

  def create
    @reservation = Reservation.new date: params.require(:date),
                                   resident: current_resident,
                                   common_area: @common_area

    redirect_to @common_area, notice: t('notices.reservation.created') if @reservation.save
  end

  def canceled
    return redirect_to @common_area, notice: t('notices.reservation.canceled') if cancel_reservation

    redirect_to @common_area, alert: t('alerts.reservation.cancelation_failed')
  end

  private

  def cancel_reservation
    Time.zone.today < @reservation.date && @reservation.canceled!
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

    return if reservation_owner?

    redirect_to root_path, alert: t('alerts.reservation.not_authorized')
  end

  def reservation_owner?
    resident_signed_in? && @reservation.resident == current_resident
  end

  def set_common_area
    @common_area = CommonArea.find params[:common_area_id]
  end

  def set_reservation
    @reservation = Reservation.find params[:id]
  end
end
