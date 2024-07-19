class BillsController < ApplicationController
  before_action :authenticate_resident!, only: %i[index]
  before_action :unit_for_current_resident
  rescue_from Faraday::ConnectionFailed, with: :connection_refused
  before_action :request_open_bills_list
  before_action :set_breadcrumbs_for_index, only: %i[index]

  def index; end

  private

  def unit_for_current_resident
    @unit = current_resident.residence
  end

  def request_open_bills_list
    @bills = Bill.request_open_bills(@unit.id)
  end

  def connection_refused
    redirect_to root_path, alert: t('alerts.bill.lost_connection')
  end

  def set_breadcrumbs_for_index
    add_breadcrumb I18n.t('breadcrumb.bill.index')
  end
end
