class UnitsController < ApplicationController
  before_action :authenticate_manager!, only: [:show]

  def show
    @unit = Unit.find params[:id]
    @tower = @unit.floor.tower
  end
end
