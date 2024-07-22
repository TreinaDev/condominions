class FinesController < ApplicationController
  before_action :set_condo, only: %i[new create]
  before_action :authorize_superintendent, only: %i[new create]
  before_action :set_breadcrumbs_for_register, only: %i[new create]

  def new
    @fine = SingleCharge.new(condo: @condo)
  end

  def create
    @fine = SingleCharge.new(fine_params)

    if @fine.valid?
      return redirect_to @condo if post_response

      flash.now.alert = t('alerts.single_charge.server_error')
    else
      flash.now.alert = t('alerts.single_charge.fine_not_created')
    end
    render 'new', status: :unprocessable_entity
  end

  private

  def set_breadcrumbs_for_register
    add_breadcrumb @condo.name.to_s, @condo
    add_breadcrumb I18n.t('breadcrumb.fine.new')
  end

  def authorize_superintendent
    return if resident_signed_in? && @condo.superintendent && @condo.superintendent.tenant == current_resident

    redirect_to root_path
  end

  def set_condo
    @condo = Condo.find params[:condo_id]
  end

  def find_tower_and_floor
    return unless params['single_charge']

    tower = Tower.find_by(id: params['single_charge']['tower_id'])
    return tower.floors[params['single_charge']['floor'].to_i - 1] if tower

    nil
  end

  def find_unit_id
    floor = find_tower_and_floor

    return floor.units[params['single_charge']['unit'].to_i - 1].id if floor

    nil
  end

  def fine_params
    params.require(:single_charge)
          .permit(:value, :description)
          .merge({ charge_type: :fine, condo: @condo, unit_id: find_unit_id })
  end

  def single_charge_params
    { single_charge: {
      description: @fine.description,
      value_cents: @fine.value_cents,
      charge_type: @fine.charge_type,
      issue_date: Time.zone.today,
      condo_id: @fine.condo.id,
      common_area_id: nil,
      unit_id: @fine.unit.id
    } }
  end

  def post_response
    request = Faraday.new(url: Rails.configuration.api['base_url'].to_s)
                     .post('/api/v1/single_charges/', single_charge_params.to_json,
                           'Content-Type' => 'application/json')
    return flash.notice = "Multa lançada com sucesso para a #{@fine.unit.print_identifier}" if request.success?

    nil
  rescue Faraday::ConnectionFailed
    nil
  end
end
