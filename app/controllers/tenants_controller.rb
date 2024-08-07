class TenantsController < ResidentsController
  before_action :set_resident
  before_action :set_condos
  before_action :set_breadcrumbs_for_register, only: %i[new create]

  def new; end

  def create
    return unless update_resident_for_valid_unit

    return @resident.mail_not_confirmed! && send_email if @resident.residence_registration_pending?

    redirect_to @resident, notice: t('notices.tenant.updated')
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
    redirect_to @resident, notice: t('notices.resident.send_email')
  end

  def update_resident_for_valid_unit
    unit = Unit.find_by(id: find_unit_id)
    alert_message = select_alert_message(unit)

    flash.now.alert = alert_message
    if alert_message
      render 'new', status: :unprocessable_entity
      return
    end
    return if unit && authorize_condo_manager(unit.condo)

    return @resident.update residence: unit unless params[:commit] == 'Não reside neste condomínio'

    @resident.update residence: nil
  end

  def property_residence?
    @resident.residence_registration_pending? &&
      @resident.properties.empty? &&
      params[:commit] == 'Não reside neste condomínio'
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
