class TenantsController < ResidentsController
  before_action :set_resident_and_condos
  def new; end

  def create
    unless params[:commit] == 'Não reside neste condomínio' || update_resident_for_valid_unit
      return render 'new', status: :unprocessable_entity
    end

    if @resident.not_tenant?
      @resident.mail_not_confirmed!
      send_email
    end

    redirect_to root_path, notice: t('notices.tenant.updated')
  end

  private

  def set_resident_and_condos
    @resident = Resident.find params[:resident_id]
    @condos = Condo.all
  end

  def send_email
    random_password = SecureRandom.alphanumeric 8
    @resident.update password: random_password
    @resident.send_invitation random_password
  end

  def update_resident_for_valid_unit
    unit = find_unit_id
    unless unit
      flash.now.alert = t('alerts.tenant.inexistent_unit')

      return nil
    end

    @resident.update residence_id: unit
    true
  end
end
