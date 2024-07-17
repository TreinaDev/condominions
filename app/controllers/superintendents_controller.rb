class SuperintendentsController < ApplicationController
  before_action :set_condo, only: %i[new create]

  def new
    @superintendet = Superintendent.new
  end

  def create; end

  private

  def set_condo
    @condo = Condo.find params[:condo_id]
  end
end