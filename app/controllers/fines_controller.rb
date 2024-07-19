class FinesController < ApplicationController
  before_action :set_condo, only: %i[new create]
  before_action :authorize_superintendent, only: %i[new create]

  def new
    @fine = SingleCharge.new(condo: @condo)
  end

  def create
    @fine = SingleCharge.new(fine_params)

    response = post_response

    if @fine.valid? && response.success?
      @fine.save
      return redirect_to @condo, notice: "Multa lançada com sucesso para a #{@fine.unit.print_identifier}"
    end
    @fine.valid?
    flash.now.alert = t('alerts.single_charge.fine_not_created')
    render 'new', status: :unprocessable_entity
  end

  private

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
    params.require(:single_charge).permit(:value_cents,
                                          :description).merge({ charge_type: :fine, condo: @condo,
                                                                unit_id: find_unit_id })
  end

  def single_charge_params
    { single_charge: {
      description: @fine.description,
      value_cents: @fine.value_cents,
      charge_type: @fine.charge_type,
      issue_date: 5.days.from_now.to_date,
      condo_id: @fine.condo.id,
      common_area_id: nil,
      unit_id: @fine.unit.id
    } }
  end

  def post_response
    Faraday.new(url: 'http://localhost:4000')
           .post('/api/v1/single_charges/', single_charge_params.to_json,
                 'Content-Type' => 'application/json')
  end
end
