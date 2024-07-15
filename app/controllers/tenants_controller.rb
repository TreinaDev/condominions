class TenantsController < ResidentsController
  before_action :set_resident
  before_action :set_condos

  def new
    add_breadcrumb I18n.t('breadcrumb.tenant.add_unit')
  end

  def create
    add_breadcrumb I18n.t('breadcrumb.tenant.add_unit')
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
    if !unit
      (flash.now.alert = t('alerts.tenant.inexistent_unit'))

      return nil
    elsif unit.tenant
      flash.now.alert = t('alerts.tenant.unit_already_used')

      return nil
    end

    @resident.update(residence: unit)
  end
end
