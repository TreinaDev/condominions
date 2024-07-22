class VisitorEntriesController < ApplicationController
  before_action :set_condo, only: %i[new create index]
  before_action :set_units, only: %i[new create]
  before_action :authenticate_manager!
  before_action :set_breadcrumbs_for_register, only: %i[new create]
  before_action :set_breadcrumbs_for_index, only: %i[index]

  def index
    return @visitor_entries = @condo.visitor_entries.order('created_at DESC') if check_empty_params

    @result = []
    params.permit(:full_name, :visit_date, :identity_number).each do |key, value|
      key = 'database_datetime' if key == 'visit_date'
      @result << find_visitor_entries(key, value) if value.present?
    end

    @visitor_entries = @result.reduce(:&)
    @visitor_entries = @visitor_entries.order('created_at DESC') if @visitor_entries.many?
  end

  def new
    @visitor_entry = VisitorEntry.new
  end

  def create
    @visitor_entry = VisitorEntry.new(visitor_entry_params)
    @visitor_entry.condo = @condo

    if @visitor_entry.save
      return redirect_to condo_visitor_entries_path(@condo),
                         notice: t('notices.visitor_entry.created')
    end

    flash.now[:alert] = t('alerts.visitor_entry.not_created')
    render :new, status: :unprocessable_entity
  end

  private

  def visitor_entry_params
    params.require(:visitor_entry).permit :full_name, :identity_number, :unit_id
  end

  def check_empty_params
    params.values_at(:identity_number, :full_name, :visit_date).all?(&:blank?)
  end

  def find_visitor_entries(key, value)
    @condo.visitor_entries.where("#{key} LIKE ?", "%#{value}%")
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def set_units
    @units = @condo.units.order :id
  end

  def set_breadcrumbs_for_register
    add_breadcrumb @condo.name.to_s, @condo
    add_breadcrumb I18n.t('breadcrumb.visitor_entry.new')
  end

  def set_breadcrumbs_for_index
    add_breadcrumb @condo.name.to_s, @condo
    add_breadcrumb I18n.t('breadcrumb.visitor_entry.index')
  end

  def authenticate_manager!
    return redirect_to root_path, alert: I18n.t('alerts.visitor_entry.access_denied') if resident_signed_in?

    super
  end
end
