class FinesController < ApplicationController
  def new
    @condo = Condo.find params[:condo_id]
    @fine = SingleCharge.new(condo: @condo)
  end

  def create
    @condo = Condo.find params[:condo_id]
    @fine = SingleCharge.new(fine_params)

    return unless @fine.save

    redirect_to @condo, notice: "Multa lançada com sucesso para a #{@fine.unit.print_identifier}"
  end

  private

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
    @condo = Condo.find params[:condo_id]
    params.require(:single_charge).permit(:value_cents,
                                          :description).merge({ charge_type: :fine, condo: @condo,
                                                                unit_id: find_unit_id })
  end
end
