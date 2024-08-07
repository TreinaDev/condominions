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

    return unless @reservation.generate_single_charge.status == 201

    @reservation.save
    redirect_to @common_area, notice: t('notices.reservation.created')
  rescue Faraday::ConnectionFailed
    redirect_to @common_area, alert: t('alerts.lost_connection')
  end

  def canceled
    return redirect_to @common_area, notice: t('notices.reservation.canceled') if cancel_reservation

    redirect_to @common_area, alert: t('alerts.reservation.cancelation_failed')
  rescue Faraday::ConnectionFailed
    redirect_to @common_area, alert: t('alerts.lost_connection')
  end

  private

  def cancel_reservation
    Time.zone.today < @reservation.date && @reservation.cancel_single_charge.status == 200 && @reservation.canceled!
  end

  def resident_access_restricted?
    resident_signed_in? && !@common_area.access_allowed?(current_resident)
  end

  def authenticate_resident!
    @residents = @common_area.condo.residents
    return super unless manager_signed_in? || resident_access_restricted?

    redirect_to root_path, alert: I18n.t('alerts.not_authorized')
  end

  def authenticate_for_cancelation
    unless anyone_signed_in?
      return redirect_to new_resident_session_path,
                         alert: I18n.t('alerts.reservation.access_denied')
    end

    return if reservation_owner?

    redirect_to root_path, alert: I18n.t('alerts.not_authorized')
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
