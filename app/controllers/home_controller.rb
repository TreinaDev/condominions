class HomeController < ApplicationController
  def index
    return redirect_to signup_choice_path unless anyone_signed_in?
    return @condos = current_manager.is_super ? Condo.all : current_manager.condos if manager_signed_in?

    @condos = current_resident.condos
  end

  def signup; end
end
