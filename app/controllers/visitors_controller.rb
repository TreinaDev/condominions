class VisitorsController < ApplicationController
  before_action :set_resident, only: %i[index new create]
  before_action :set_condo, only: %i[find]
  before_action :set_visitor, only: %i[confirm_entry]
  before_action :authenticate_resident!, only: %i[index new create]
  before_action :set_breadcrumbs_for_action, only: %i[new create]
  before_action :authenticate_manager!, only: %i[find confirm_entry]
  before_action -> { authorize_condo_manager!(@condo) }, only: %i[find confirm_entry]

  def index
    @visitors = @resident.visitors
  end

  def find
    @date = params[:date].present? ? params[:date].to_date : Time.zone.today
    unless @date >= Time.zone.today
      return redirect_to find_condo_visitors_path(@condo), alert: I18n.t('alerts.visitor.invalid_list_date')
    end

    @visitors = @condo.expected_visitors(@date)
  end

  def confirm_entry
    return redirect_to find_condo_visitors_path(@visitor.condo) unless check_visitor(@visitor)

    VisitorEntry.create(visitor_entry_params)
    @visitor.confirmed!

    redirect_to find_condo_visitors_path(@visitor.condo), notice: I18n.t('notice.visitor.entry_confirmed')
  end

  def new
    @visitor = Visitor.new
  end

  def create
    @visitor = Visitor.new(visitor_params)
    unless @visitor.save
      flash.now[:alert] = t('alerts.visitor.not_created')
      return render :new, status: :unprocessable_entity
    end
    set_visit_date_job
    redirect_to resident_visitors_path(@resident), notice: I18n.t('notice.visitor.created')
  end

  private

  def check_visitor(visitor)
    if visitor.confirmed?
      flash[:alert] = I18n.t('alerts.visitor.already_confirmed')
      return false
    end

    unless visitor.visit_date == Time.zone.today
      flash[:alert] = I18n.t('alerts.visitor.invalid_date')
      return false
    end

    true
  end

  def set_visit_date_job
    return unless @visitor.employee?

    UpdateVisitDateJob.set(wait_until: (@visitor.visit_date + 1.day).to_datetime).perform_later(@visitor)
  end

  def set_breadcrumbs_for_action
    add_breadcrumb @resident.residence.condo.name, @resident.residence.condo
    add_breadcrumb I18n.t("breadcrumb.visitor.#{action_name}")
  end

  def authenticate_resident!
    return redirect_to root_path, alert: I18n.t('alerts.visitor.manager_block') if manager_signed_in?

    if resident_signed_in?
      return redirect_to root_path, alert: I18n.t('alerts.visitor.not_tenant') if @resident.residence.nil?
      return redirect_to root_path, alert: I18n.t('alerts.visitor.not_allowed') unless current_resident == @resident
    end

    super
  end

  def authenticate_manager!
    return redirect_to root_path, alert: I18n.t('alerts.visitor.resident_block') if resident_signed_in?

    super
  end

  def set_resident
    @resident = Resident.find(params[:resident_id])
  end

  def set_condo
    @condo = Condo.find(params[:condo_id])
  end

  def set_visitor
    @visitor = Visitor.find(params[:id])
  end

  def visitor_entry_params
    {
      full_name: @visitor.full_name, identity_number: @visitor.identity_number,
      unit_id: @visitor.resident.residence.id, condo_id: @visitor.condo_id
    }
  end

  def visitor_params
    params.require(:visitor).permit(:full_name, :identity_number, :visit_date, :category,
                                    :recurrence).merge resident: @resident, condo: @resident.residence.condo
  end
end
