class BillsController < ApplicationController
  #before_action :authenticate_resident!, only: %i[index]
  before_action :unit_for_current_resident
  rescue_from Faraday::ConnectionFailed, with: :connection_refused
  before_action :request_open_bills_list
  def index; end
end

private

def unit_for_current_resident
  @unit = current_resident.residence
end

def request_open_bills_list
  @bills = Bill.request_open_bills(@unit.id)
end

def connection_refused
  redirect_to root_path, notice: t('alerts.bill.lost_connection')
end
