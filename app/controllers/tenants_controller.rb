class TenantsController < ResidentsController
  before_action :set_resident
  before_action :set_condos

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

  def set_resident
    @resident = Resident.find params[:resident_id]
  end

  def set_condos
    @condos = Condo.all
  end

  def send_email
    random_password = SecureRandom.alphanumeric 8
    @resident.update password: random_password
    @resident.send_invitation random_password
  end

  def update_resident_for_valid_unit
    unit = Unit.find_by(id: find_unit_id)
    alert_message = select_alert_message(unit)
    if alert_message
      flash.now.alert = alert_message
      return nil
    end
    @resident.update residence: unit
  end

  def select_alert_message(unit)
    return t('alerts.tenant.inexistent_unit') unless unit
    return t('alerts.tenant.unit_already_used') if unit.tenant

    t('alerts.tenant.unit_do_not_have_owner') unless unit.owner
  end
end
