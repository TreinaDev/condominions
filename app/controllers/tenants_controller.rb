class TenantsController < ResidentsController
  before_action :set_resident
  before_action :set_condos
  before_action :set_breadcrumbs_for_register, only: %i[new create]

  def new
    add_breadcrumb I18n.t('breadcrumb.tenant.add_unit')
  end

  def create
    return render 'new', status: :unprocessable_entity unless update_resident_for_valid_unit

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
    return @condos = Condo.all if current_manager.is_super?

    @condos = current_manager.condos
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
    @resident.update residence: unit unless params[:commit] == 'Não reside neste condomínio'
    true
  end

  def property_residence?
    @resident.not_tenant? && @resident.properties.empty? && params[:commit] == 'Não reside neste condomínio'
  end

  def select_alert_message(unit)
    return I18n.t('alerts.tenant.property_residence_nill') if property_residence?
    return if params[:commit] == 'Não reside neste condomínio'
    return I18n.t('alerts.tenant.inexistent_unit') unless unit
    return I18n.t('alerts.tenant.unit_already_used') if unit.tenant

    t('alerts.tenant.unit_do_not_have_owner') unless unit.owner
  end

  def set_breadcrumbs_for_register
    add_breadcrumb I18n.t('breadcrumb.owner.new'), new_resident_owner_path(@resident.id)
    add_breadcrumb I18n.t('breadcrumb.tenant.new')
  end
end
