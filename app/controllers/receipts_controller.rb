class ReceiptsController < ApplicationController
  before_action :authenticate_resident!, only: %i[create new]

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
end
