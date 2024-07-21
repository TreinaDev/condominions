class ApplicationController < ActionController::Base
  include Warnings

  before_action :resident_registration_incomplete
  before_action :block_manager_from_resident_sign_in
  before_action :block_resident_from_manager_sign_in
  before_action :add_home_breadcrumb, unless: :devise_controller?

  def add_home_breadcrumb
    add_breadcrumb 'Home', :root_path
  end

  private

  def anyone_signed_in?
    manager_signed_in? || resident_signed_in?
  end

  def devise_controller?
    devise_controller_name = %w[sessions]
    devise_controller_name.include?(controller_name)
  end

  def authorize_super_manager
    not_authorized_redirect unless current_manager.is_super
  end

  def authorize_condo_manager_superintendent(condo)
    return if authorize_manager(condo) || (authorize_resident(condo) && current_resident&.superintendent)

    not_authorized_redirect
  end

  def authorize_condo_manager(condo)
    not_authorized_redirect unless authorize_manager(condo)
  end

  def authorize_condo_resident(condo)
    not_authorized_redirect if authorize_resident(condo)
  end

  def authorize_user(condo)
    not_authorized_redirect unless authorize_manager(condo) || authorize_resident(condo)
  end

  def authorize_manager(condo)
    return unless manager_signed_in?

    current_manager.is_super || current_manager.condos.include?(condo)
  end

  def authorize_resident(condo)
    resident_signed_in? && condo && condo.residents.include?(current_resident)
  end

  def not_authorized_redirect
    redirect_to root_path, alert: I18n.t('alerts.not_authorized')
  end

  def block_manager_from_resident_sign_in
    redirect_to root_path if manager_signed_in? && request.path == new_resident_session_path
  end

  def block_resident_from_manager_sign_in
    redirect_to root_path if resident_signed_in? && request.path == new_manager_session_path
  end

  def resident_registration_incomplete
    valid_actions = %w[destroy confirm update]

    return unless resident_signed_in?
    return if valid_actions.include?(action_name)

    redirect_to confirm_resident_path(current_resident) if current_resident.mail_not_confirmed?
  end
end
