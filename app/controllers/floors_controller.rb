class FloorsController < ApplicationController
  def show
    @tower = Tower.find params[:tower_id]
    @floor = Floor.find params[:id]
  end
end
