class ResidentsController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create find_towers show]
  before_action :set_resident, only: %i[update edit_photo update_photo show]
  before_action :authenticate_resident!, only: %i[update edit_photo update_photo]

  def show
    add_breadcrumb I18n.t('breadcrumb.resident.show')
  end

  def new
    add_breadcrumb I18n.t('breadcrumb.resident.new')
    @resident = Resident.new
    @condos = Condo.all
  end

  def create
    add_breadcrumb I18n.t('breadcrumb.resident.new')
    @condos = Condo.all
    random_password = SecureRandom.alphanumeric(8)
    @resident = Resident.new(resident_params.merge!(password: random_password))

    return redirect_to_existent_resident if registration_number_taken

    return render :new, status: :unprocessable_entity unless @resident.save

    redirect_to new_resident_owner_path(@resident), notice: t('notices.resident.created')
  end

  def registration_number_taken
    true if !@resident.valid? && @resident.errors.full_messages.include?('CPF já está em uso')
  end

  def redirect_to_existent_resident
    resident = Resident.find_by registration_number: @resident.registration_number
    flash.alert = 'Morador já cadastro, redirecionado para a página de detalhes do morador'
    redirect_to resident_path resident
  end

  def update
    resident_params = params['resident']

    @resident.update(user_image: resident_params['user_image']) if resident_params

    @resident.mail_confirmed!
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

    redirect_to root_path if @resident.mail_confirmed?
  end

  def edit_photo
    add_breadcrumb I18n.t('breadcrumb.resident.edit_photo')
  end

  def update_photo
    add_breadcrumb I18n.t('breadcrumb.resident.edit_photo')
    return render :edit_photo, status: :unprocessable_entity unless @resident.update(user_image_params)

    redirect_to root_path, notice: I18n.t('notices.resident.updated_photo')
  end

  protected

  def find_tower_and_floor
    return unless params['resident']

    tower = Tower.find_by(id: params['resident']['tower_id'])
    return tower.floors[params['resident']['floor'].to_i - 1] if tower

    nil
  end

  def find_unit_id
    floor = find_tower_and_floor

    return floor.units[params['resident']['unit'].to_i - 1].id if floor

    nil
  end

  private

  def authenticate_resident!
    return redirect_to root_path if manager_signed_in?

    super
    redirect_to root_path if current_resident != Resident.find(params[:id])
  end

  def set_resident
    @resident = Resident.find params[:id]
  end

  def authenticate_manager!
    return redirect_to root_path if resident_signed_in?

    super
  end

  def resident_params
    params.require(:resident).permit :full_name, :registration_number, :email
  end

  def user_image_params
    params.require(:resident).permit :user_image
  end
end
