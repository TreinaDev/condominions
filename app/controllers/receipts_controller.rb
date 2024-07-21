class ReceiptsController < ApplicationController
  before_action :authenticate_resident!, only: %i[create new]
  before_action :set_breadcrumbs_for_action, only: :new

  def new
    @bill_id = params[:bill_id]
  end

  def create
    current_resident.update(receipt: params[:image])
    response = Bill.send_post_request(current_resident, params[:bill_id])
    message = Bill.render_message(response)
    redirect_to bills_path, flash: message
  end

  private

  def set_breadcrumbs_for_action
    add_breadcrumb I18n.t("breadcrumb.receipt.#{action_name}")
  end
end
