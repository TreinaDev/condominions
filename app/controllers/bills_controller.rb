class BillsController < ApplicationController
  rescue_from Faraday::ConnectionFailed, with: :connection_refused
  before_action :authenticate_resident!, only: %i[index show]
  before_action :unit_for_current_resident
  before_action :request_open_bills_list, only: :index
  before_action :request_bill_details, only: :show
  before_action :set_breadcrumbs_for_action, only: %i[index show]

  def index; end

  def show; end

  def new
    @bill_id = params[:bill_id]
  end

  def create
    image = current_resident.user_image
    attached = image.attachment
    blob = attached.blob

    url = Rails.application.routes.url_helpers.rails_blob_url(blob, host: 'localhost:3000')
    Faraday.post('http://localhost:4000/api/v1/receipts', { receipt: url, bill_id: 4 }.to_json,
                 'Content-Type' => 'application/json')
  end

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
    redirect_to root_path, alert: t('alerts.bill.lost_connection')
  end

  def set_breadcrumbs_for_action
    add_breadcrumb I18n.t("breadcrumb.bill.#{action_name}")
  end
end
