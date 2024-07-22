class ReceiptsController < ApplicationController
  before_action :authenticate_resident!, only: %i[create new]
  before_action :define_resident, only: %i[create new]
  before_action :set_bill_id, only: %i[create new]
  before_action :set_unit_id, only: %i[new create]
  before_action :autorize_resident, only: %i[new create]
  before_action :check_image_presence, only: :create
  before_action :set_breadcrumbs_for_action, only: :new

  def new; end

  def create
    render 'new' unless @resident.update(receipt: params[:image])
    response = Bill.send_post_request(current_resident, params[:bill_id])
    message = Bill.render_message(response)
    redirect_to bills_path, flash: message
  end

  private

  def set_breadcrumbs_for_action
    add_breadcrumb I18n.t("breadcrumb.receipt.#{action_name}")
  end

  def define_resident
    @resident = current_resident
  end

  def set_bill_id
    @bill_id = params[:bill_id]
  end

  def check_image_presence
    return if params[:image].present?

    @resident.add_error
    render 'new', status: :unprocessable_entity
  end

  def set_unit_id
    @unit_id = params[:unit_id]
  end

  def autorize_resident
    redirect_to root_path, alert: t('alerts.receipt.not_autorized') unless @unit_id.to_i == @resident.residence.id
  end
end
