class VisitorEntriesController < ApplicationController
  before_action :set_condo, only: %i[new create]
  before_action :set_units, only: %i[new create]
  before_action :authenticate_manager!

  def index
    @visitor_entries = VisitorEntry.all
  end

  def new
    @visitor_entry = VisitorEntry.new
  end

  def create
    @visitor_entry = VisitorEntry.new(visitor_entry_params)
    @visitor_entry.condo = @condo

    if @visitor_entry.save
      redirect_to condo_visitor_entries_path(@condo), notice: t('notices.visitor_entry.created')
    else
      flash.now[:alert] = t('alerts.visitor_entry.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def visitor_entry_params
    params.require(:visitor_entry).permit :full_name, :identity_number, :unit_id
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def set_units
    @units = @condo.units.order :id
  end
end
