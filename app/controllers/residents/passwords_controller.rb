module Residents
  class PasswordsController < Devise::PasswordsController
    before_action :logout_current_user, only: [:edit]

    protected

    def logout_current_user
      sign_out(current_manager || current_resident) if manager_signed_in? || resident_signed_in?
    end
  end
end
