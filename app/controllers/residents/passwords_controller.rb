module Residents
  class PasswordsController < Devise::PasswordsController
    def edit
      add_breadcrumb I18n.t('breadcrumb.resident.edit_password')
      self.resource = find_resource_by_token

      return redirect_to root_path, alert: t('alerts.resident.invalid_token') unless valid_token?

      sign_out(current_manager || current_resident) if anyone_signed_in?
      super
    end

    private

    def find_resource_by_token
      resource_class.with_reset_password_token(params[:reset_password_token])
    end

    def valid_token?
      resource.present? && resource.reset_password_period_valid?
    end
  end
end
