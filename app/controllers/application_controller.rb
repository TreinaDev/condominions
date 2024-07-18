class ApplicationController < ActionController::Base
  before_action :warn_tower_registration_incomplete
  before_action :warn_resident_incomplete_tenant
  before_action :warn_resident_incomplete_owner
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

  def authorize_super_manager!
    authorize_redirect unless current_manager.is_super
  end

  def authorize_condo_manager!(condo)
    authorize_redirect unless check_manager(condo)
  end

  def authorize_condo_resident!(condo)
    authorize_redirect if check_resident(condo)
  end

  def authorize_condo_manager_or_resident!(condo)
    authorize_redirect unless check_manager(condo) || check_resident(condo)
  end

  def check_manager(condo)
    (manager_signed_in? && current_manager.is_super) ||
      (manager_signed_in? && current_manager.condos.include?(condo))
  end

  def check_resident(condo)
    resident_signed_in? && current_resident.condo == condo
  end

  def authorize_redirect
    redirect_to root_path, alert: I18n.t('alerts.manager.not_authorized')
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

    Tower.incomplete.each do |tower|
      flash.now[:warning] ||= ''
      flash.now[:warning] << tower_warning_flash_message(tower)
    end
  end

  def warn_resident_incomplete_tenant
    return unless manager_signed_in?
    return if controller_name == 'tenants' && action_name == 'new'

    Resident.not_tenant.each do |resident|
      flash.now[:warning] ||= ''
      flash.now[:warning] << resident_not_tenant_message(resident)
    end
  end

  def warn_resident_incomplete_owner
    return unless manager_signed_in?
    return if controller_name == 'owners' && action_name == 'new'

    Resident.not_owner.each do |resident|
      flash.now[:warning] ||= ''
      flash.now[:warning] << resident_not_owner_message(resident)
    end
  end

  def tower_warning_flash_message(tower)
    view_context.link_to(
      view_context.sanitize(tower.warning_html_message), edit_floor_units_condo_tower_path(tower.condo, tower),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end

  def resident_not_tenant_message(resident)
    view_context.link_to(
      view_context.sanitize(resident.warning_html_message_tenant), new_resident_tenant_path(resident),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end

  def resident_not_owner_message(resident)
    view_context.link_to(
      view_context.sanitize(resident.warning_html_message_owner), new_resident_owner_path(resident),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end
end
