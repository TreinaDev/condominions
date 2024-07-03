class UnitsController < ApplicationController
  def show
    @unit = Unit.find params[:id]
    @tower = @unit.floor.tower
  end
end
