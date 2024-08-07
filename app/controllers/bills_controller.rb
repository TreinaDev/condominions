class BillsController < ApplicationController
  rescue_from Faraday::ConnectionFailed, with: :connection_refused
  before_action :authenticate_resident!, only: %i[index show]
  before_action :unit_for_current_resident, only: %i[index show]
  before_action :request_open_bills_list, only: :index
  before_action :request_bill_details, only: :show
  before_action :autorize_resident, only: :show
  before_action :set_breadcrumbs_for_action, only: %i[index show]

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
    @bill_id = params[:id]
    @bill = Bill.request_bill_details(params[:id])

    redirect_to bills_path, alert: t('alerts.bill.not_found') unless @bill
  end

  def connection_refused
    redirect_to root_path, alert: t('alerts.lost_connection')
  end

  def set_breadcrumbs_for_action
    add_breadcrumb I18n.t("breadcrumb.bill.#{action_name}")
  end

  def autorize_resident
    redirect_to root_path, alert: t('alerts.receipt.not_autorized') unless @bill.unit_id == @unit.id
  end
end
