class HomeController < ApplicationController
  def index
    redirect_to signup_choice_path unless manager_signed_in? || resident_signed_in?
    @condos = Condo.all
  end

  def signup; end
end
