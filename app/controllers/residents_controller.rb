class ResidentsController < ApplicationController
  before_action :check_resident, only: %i[new create find_towers]
  before_action :authenticate_manager!, only: %i[new create find_towers]

  def new
    @resident = Resident.new
    @condos = Condo.all
  end

  def create
    @condos = Condo.all

    @resident = Resident.new(resident_params)
    if @resident.save
      redirect_to root_path, notice: "Convite enviado com sucesso para #{@resident.full_name} (#{@resident.email})"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def find_towers
    condo = Condo.find_by(id: params[:id])
    if condo
      towers = condo.towers
      if towers.any?
        render json: condo.towers.to_json(only: %i[id name units_per_floor floor_quantity])
      else
        render status: :not_found, json: []
      end
    else
      render status: :not_found, json: []
    end
  end

  private

  def resident_params
    resident_params = params.require(:resident).permit(:full_name, :registration_number, :email,
                                                       :resident_type)
    resident_params.merge!({ password: SecureRandom.alphanumeric(8), unit_id: find_unit_id })
  end

  def find_tower_and_floor
    tower = Tower.find_by(id: params['resident']['tower_id'])
    return tower.floors[params['resident']['floor'].to_i - 1 ] if tower

    nil
  end

  def find_unit_id
    floor = find_tower_and_floor

    return floor.units[params['resident']['unit'].to_i - 1 ].id if floor

    nil
  end

  def check_resident
    redirect_to root_path if resident_signed_in?
  end
end
