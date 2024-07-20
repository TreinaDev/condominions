module Warnings
  extend ActiveSupport::Concern
  include WarningHelper

  included do
    before_action :warn_tower_registration_incomplete
    before_action :warn_resident_incomplete
    before_action :warn_resident_photo
  end

  private

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
      generate_filtered_property_registration_pendings_messages condo
      generate_filtered_residence_registration_pendings_messages condo
    end
  end

  def generate_filtered_property_registration_pendings_messages(condo)
    condo.filtered_property_registration_pendings.each do |resident|
      flash.now[:warning] ||= ''
      flash.now[:warning] << resident_property_registration_pending_message(resident)
    end
  end

  def generate_filtered_residence_registration_pendings_messages(condo)
    condo.filtered_residence_registration_pendings.each do |resident|
      flash.now[:warning] ||= ''
      flash.now[:warning] << resident_residence_registration_pending_message(resident)
    end
  end
end
