class ApplicationController < ActionController::Base
  include WarningHelper

  before_action :warn_tower_registration_incomplete
  before_action :warn_resident_incomplete
  before_action :resident_registration_incomplete
  before_action :warn_resident_photo
  before_action :block_manager_from_resident_sign_in
  before_action :block_resident_from_manager_sign_in
  before_action :add_home_breadcrumb, unless: :devise_controller?

  def add_home_breadcrumb
    add_breadcrumb 'Home', :root_path
  end

  private

  def devise_controller?
    devise_controller_name = %w[sessions]
    devise_controller_name.include?(controller_name)
  end

  def authorize_super_manager
    authorize_redirect unless current_manager.is_super
  end

  def authorize_condo_manager(condo)
    authorize_redirect unless authorize_manager(condo)
  end

  def authorize_condo_resident(condo)
    authorize_redirect if authorize_resident(condo)
  end

  def authorize_user(condo)
    authorize_redirect unless authorize_manager(condo) || authorize_resident(condo)
  end

  def authorize_manager(condo)
    return unless manager_signed_in?

    current_manager.is_super || current_manager.condos.include?(condo) if manager_signed_in?
  end

  def authorize_resident(condo)
    resident_signed_in? && condo.residents.include?(current_resident)
  end

  def authorize_redirect
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

  def warn_resident_photo
    return unless resident_signed_in?

    warning_message = current_resident.photo_warning_html_message
    flash.now[:warning] = warning_message if warning_message
  end

  def warn_tower_registration_incomplete
    return unless manager_signed_in?
    return if controller_name == 'towers' && action_name == 'edit_floor_units'

    generate_tower_registration_messages(current_manager.is_super? ? Condo.all : current_manager.condos)
  end

  def generate_tower_registration_messages(condos)
    condos.each do |condo|
      condo.towers.incomplete.each do |tower|
        flash.now[:warning] ||= ''
        flash.now[:warning] << tower_warning_flash_message(tower)
      end
    end
  end

  def warn_resident_incomplete
    return unless manager_signed_in?
    return if controller_name == 'owners' && action_name == 'new'

    generate_incomplete_resident_messages(current_manager.is_super? ? Condo.all : current_manager.condos)
  end

  def generate_incomplete_resident_messages(condos)
    condos.each do |condo|
      generate_filtered_not_owners_messages condo
      generate_filtered_not_tenants_messages condo
    end
  end

  def generate_filtered_not_owners_messages(condo)
    condo.filtered_not_owners.each do |resident|
      flash.now[:warning] ||= ''
      flash.now[:warning] << resident_not_owner_message(resident)
    end
  end

  def generate_filtered_not_tenants_messages(condo)
    condo.filtered_not_tenants.each do |resident|
      flash.now[:warning] ||= ''
      flash.now[:warning] << resident_not_tenant_message(resident)
    end
  end
end
