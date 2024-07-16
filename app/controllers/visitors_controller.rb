class VisitorsController < ApplicationController
  before_action :set_resident, only: %i[index new create]

  def index
    @visitors = @resident.visitors
  end

  def new
    @visitor = Visitor.new
  end

  def create
    @visitor = Visitor.new(visitor_params)
    return unless @visitor.save!

    redirect_to resident_visitors_path(@resident), notice: I18n.t('notice.visitor.created')
  end

  private

  def set_resident
    @resident = Resident.find(params[:resident_id])
  end

  def visitor_params
    params.require(:visitor).permit(:full_name, :identity_number, :visit_date, :category,
                                    :recurrence).merge resident: @resident
  end
end
