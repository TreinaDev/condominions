class ResidentsController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create find_towers]
  before_action :set_resident, only: %i[update]

  def new
    @resident = Resident.new
    @condos = Condo.all
  end

  def create
    @condos = Condo.all
    random_password = SecureRandom.alphanumeric(8)
    @resident = Resident.new(resident_params.merge!(password: random_password))

    return render :new, status: :unprocessable_entity unless @resident.save

    @resident.send_invitation(random_password)
    redirect_to root_path, notice: "Convite enviado com sucesso para #{@resident.full_name} (#{@resident.email})"
  end

  def update
    resident_params = params.require(:resident).permit :password, :password_confirmation, :user_image
    password = resident_params['password']
    password_confirmation = resident_params['password_confirmation']

    if password_confirmation_invalid?(password, password_confirmation) ||
       password_same_as_current?(password) || !@resident.update(resident_params)

      return render 'confirm', status: :unprocessable_entity
    end

    @resident.update status: :confirmed
    bypass_sign_in @resident
    redirect_to root_path, notice: t('notices.resident.updated')
  end

  def find_towers
    condo = Condo.find_by(id: params[:id])
    return render status: :not_found, json: [] unless condo

    towers = condo.towers
    return render status: :not_found, json: [] if towers.empty?

    render json: condo.towers.to_json(only: %i[id name units_per_floor floor_quantity])
  end

  def confirm
    @resident = current_resident
  end

  private

  def set_resident
    @resident = Resident.find params[:id]
  end

  def password_same_as_current?(password)
    return false unless @resident.valid_password?(password)

    @resident.errors.add :password, 'deve ser diferente da atual'
    true
  end

  def password_confirmation_invalid?(password, password_confirmation)
    return false unless password != password_confirmation

    @resident.errors.add :password_confirmation, 'deve ser igual a senha'
    true
  end

  def authenticate_manager!
    return redirect_to root_path if resident_signed_in?

    super
  end

  def resident_params
    resident_params = params.require(:resident).permit(:full_name, :registration_number, :email,
                                                       :resident_type)
    resident_params.merge!({ unit_id: find_unit_id })
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
end
