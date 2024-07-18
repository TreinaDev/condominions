class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show canceled]
  before_action :set_common_area, only: %i[new create]
  before_action :set_breadcrumbs, only: [:new]
  before_action :block_manager_from_resident_sign_in, only: %i[new create]
  before_action :authenticate_resident!, only: %i[new create]
  before_action :authenticate_for_cancelation, only: [:canceled]
  before_action :authorize_user, only: [:show]

  def show
    @common_area = @reservation.common_area
    set_breadcrumbs
  end

  def new
    @reservation = Reservation.new common_area: @common_area
  end

  def create
    @reservation = Reservation.new reservation_params
    @reservation.resident = current_resident
    @reservation.common_area = @common_area

    return redirect_to @reservation, notice: t('notices.reservation.created') if @reservation.save

    flash.now[:alert] = I18n.t 'alerts.reservation.not_created'
    render 'new', status: :unprocessable_entity
  end

  def canceled
    @reservation.canceled!
    redirect_to @reservation, notice: t('notices.reservation.canceled')
  end

  private

  def reservation_params
    params.require(:reservation).permit :date
  end

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
    return if !authenticate_user || super_manager? || can_access_condo? || reservation_owner?

    redirect_to root_path, alert: t('alerts.reservation.not_authorized')
  end

  def authenticate_user
    return true if manager_signed_in? || resident_signed_in?

    redirect_to signup_choice_path
    false
  end

  def super_manager?
    manager_signed_in? && current_manager.is_super
  end

  def can_access_condo?
    manager_signed_in? && current_manager.condos.include?(@reservation.common_area.condo)
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
