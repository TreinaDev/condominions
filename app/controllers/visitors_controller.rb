class VisitorsController < ApplicationController
  before_action :set_resident, only: %i[index new create]
  before_action :authenticate_resident!, only: %i[index new create]

  def index
    @visitors = @resident.visitors
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
    redirect_to resident_visitors_path(@resident), notice: I18n.t('notice.visitor.created')
  end

  private

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
