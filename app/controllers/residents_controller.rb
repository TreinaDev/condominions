class ResidentsController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create find_towers]
  before_action :set_resident, only: %i[update edit_photo update_photo]
  before_action :authenticate_resident!, only: %i[update edit_photo update_photo]

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

    return render :new, status: :unprocessable_entity unless @resident.save

    #@resident.send_invitation(random_password)
    redirect_to new_resident_tenant_path(@resident), notice: t('notices.resident.created')
  end

  def update
    resident_params = params.require(:resident).permit :password, :password_confirmation, :user_image
    password = resident_params['password']
    password_confirmation = resident_params['password_confirmation']

    if @resident.password_confirmation_invalid?(password, password_confirmation) ||
       @resident.password_same_as_current?(password) || !@resident.update(resident_params)

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

    redirect_to root_path if @resident.confirmed?
  end

  def edit_photo; end

  def update_photo
    return render :edit_photo, status: :unprocessable_entity unless @resident.update(user_image_params)

    redirect_to root_path, notice: I18n.t('notices.resident.updated_photo')
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
    params.require(:resident).permit(:full_name, :registration_number, :email)
  end

  def user_image_params
    params.require(:resident).permit(:user_image)
  end
end
