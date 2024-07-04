class ResidentsController < ApplicationController
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
    render json: Condo.find(params[:id]).towers.to_json(only: %i[id name units_per_floor floor_quantity])
  end

  private

  def resident_params
    resident_params = params.require(:resident).permit(:full_name, :registration_number, :email, :password,
                                                       :resident_type)
    resident_params.merge!({ unit_id: find_unit_id })
  end

  def find_tower_and_floor
    tower = Tower.find(params['resident']['tower_id'])
    tower.floors[params['resident']['floor'].to_i - 1 ]
  end

  def find_unit_id
    floor = find_tower_and_floor
    floor.units[params['resident']['unit'].to_i - 1 ].id
  end
end
