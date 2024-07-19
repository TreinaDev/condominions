class BillsController < ApplicationController
  before_action :authenticate_resident!, only: %i[index show]
  before_action :unit_for_current_resident
  rescue_from Faraday::ConnectionFailed, with: :connection_refused
  before_action :request_open_bills_list, only: :index
  before_action :request_bill_details, only: :show
  before_action :find_bill_unit, only: :show
  before_action :set_breadcrumbs_for_index, only: :index
  before_action :set_breadcrumbs_for_details, only: :show

  def index; end

  def show; end

  private

  def unit_for_current_resident
    @unit = current_resident.residence
  end

  def request_open_bills_list
    @bills = Bill.request_open_bills(@unit.id)
  end

  def request_bill_details
    @bill = Bill.request_bill_details(params[:id])
  end

  def connection_refused
    redirect_to root_path, alert: t('alerts.bill.lost_connection')
  end

  def set_breadcrumbs_for_index
    add_breadcrumb I18n.t('breadcrumb.bill.index')
  end

  def set_breadcrumbs_for_details
    add_breadcrumb I18n.t('breadcrumb.bill.show')
  end

  def find_bill_unit
    @unit = Unit.find(@bill.unit_id)
  end
end
