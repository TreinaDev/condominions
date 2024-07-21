class ReceiptsController < ApplicationController
  before_action :authenticate_resident!, only: %i[create new]

  def new
    @bill_id = params[:bill_id]
  end

  def create
    current_resident.update(receipt: params[:image])
    response = Bill.send_post_request(current_resident, params[:bill_id])
    message = Bill.render_message(response)
    redirect_to bills_path, flash: message
  end
end
