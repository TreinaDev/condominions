class HomeController < ApplicationController
  def index
    redirect_to signup_choice_path unless manager_signed_in? || resident_signed_in?
    return @condos = Condo.all if manager_signed_in? && current_manager.is_super

    return @condos = current_manager.condos if manager_signed_in? && !current_manager.is_super

    @condos = Condo.all
  end

  def signup; end
end
