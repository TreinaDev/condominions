class VisitorsController < ApplicationController
  before_action :set_resident, only: %i[index new create]
  before_action :authenticate_resident!, only: %i[index new create]
  before_action :set_breadcrumbs_for_register, only: %i[new create]
  before_action :set_breadcrumbs_for_index, only: %i[index]

  def index
    @visitors = @resident.visitors
  end

  def new
    @visitor = Visitor.new
  end

  def create
    @visitor = Visitor.new(visitor_params)
    unless @visitor.save
      set_visit_date_job
      flash.now[:alert] = t('alerts.visitor.not_created')
      return render :new, status: :unprocessable_entity
    end
    redirect_to resident_visitors_path(@resident), notice: I18n.t('notice.visitor.created')
  end

  private

  def set_visit_date_job
    return unless @visitor.employee?

    UpdateVisitDateJob.set(wait_until: (@visitor.visit_date + 1.day).to_datetime).perform_later(@visitor)
  end

  def set_breadcrumbs_for_register
    add_breadcrumb @resident.residence.condo.name, @resident.residence.condo
    add_breadcrumb I18n.t('breadcrumb.visitor.new')
  end

  def set_breadcrumbs_for_index
    add_breadcrumb @resident.residence.condo.name, @resident.residence.condo
    add_breadcrumb I18n.t('breadcrumb.visitor.index')
  end

  def authenticate_resident!
    return redirect_to root_path, alert: I18n.t('alerts.visitor.manager_block') if manager_signed_in?

    if resident_signed_in?
      return redirect_to root_path, alert: I18n.t('alerts.visitor.not_tenant') if @resident.residence.nil?
      return redirect_to root_path, alert: I18n.t('alerts.visitor.not_allowed') if current_resident != @resident
    end

    super
  end

  def set_resident
    @resident = Resident.find(params[:resident_id])
  end

  def visitor_params
    params.require(:visitor).permit(:full_name, :identity_number, :visit_date, :category,
                                    :recurrence).merge resident: @resident
  end
end
