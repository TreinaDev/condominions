class ResidentsController < ApplicationController
  def new
    @resident = Resident.new
    @condos = Condo.all
    @towers = Tower.all
    @units = Unit.all
  end
end
