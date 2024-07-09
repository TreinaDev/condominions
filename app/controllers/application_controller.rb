class ApplicationController < ActionController::Base
  before_action :warn_tower_registration_incomplete
  before_action :resident_registration_incomplete
  before_action :warn_resident_photo
  add_breadcrumb 'Home', :root_path

  private

  def resident_registration_incomplete
    valid_actions = %w[destroy confirm update]

    return unless resident_signed_in?
    return if valid_actions.include?(action_name)

    redirect_to confirm_resident_path(current_resident) if current_resident.not_confirmed?
  end

  def warn_resident_photo
    return unless resident_signed_in?
    return if current_resident.not_confirmed?
    return if current_resident.user_image.attached?

    flash.now[:warning] = t('warning.resident.user_image')
    flash.now[:warning] << "<a href='rota'>>Editar Foto<</a>"
  end

  def warn_tower_registration_incomplete
    return unless manager_signed_in?
    return if controller_name == 'towers' && action_name == 'edit_floor_units'

    Tower.incomplete.each do |tower|
      flash.now[:warning] ||= ''
      flash.now[:warning] << tower_warning_flash_message(tower)
    end
  end

  def tower_warning_flash_message(tower)
    view_context.link_to(
      view_context.sanitize(tower.warning_html_message), edit_floor_units_condo_tower_path(tower.condo, tower),
      class: 'link-dark link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover'
    )
  end
end
