class OwnersController < ResidentsController
  before_action :authenticate_manager!, only: %i[create new destroy]
  before_action :set_resident
  before_action :set_condos
  before_action :set_breadcrumbs_for_register, only: %i[new create]

  def new; end

  def create
    return if finish_ownership_register

    unit = Unit.find_by id: find_unit_id
    return if any_redirect? unit

    unless unit.owner
      @resident.properties << unit
      return redirect_to new_resident_owner_path(@resident), notice: t('notices.owner.updated')
    end

    flash.now.alert = t('alerts.owner.duplicated_unit')
    render 'new', status: :unprocessable_entity
  end

  def destroy
    unit = Unit.find params[:id]
    return if authorize_condo_manager(unit.condo)

    unit.update(owner: nil)
    redirect_to new_resident_owner_path(@resident), notice: t('notices.owner.unit_removed')
  end

  private

  def set_resident
    @resident = Resident.find params[:resident_id]
  end

  def set_condos
    return @condos = Condo.all if current_manager.is_super?

    @condos = current_manager.condos
  end

  def finish_ownership_register
    return unless params[:commit] == 'Finalizar Cadastro de Propriedades'

    @resident.residence_registration_pending! if @resident.property_registration_pending?
    redirect_to new_resident_tenant_path(@resident), notice: t('notices.owner.finalized')
  end

  def inexistent_unit(unit)
    return nil unless params[:commit] == 'Adicionar Propriedade' && !unit

    flash.now.alert = t('alerts.owner.inexistent_unit')
    render 'new', status: :unprocessable_entity
  end

  def set_breadcrumbs_for_register
    add_breadcrumb I18n.t('breadcrumb.owner.new')
  end

  def any_redirect?(unit)
    inexistent_unit(unit) || authorize_condo_manager(unit.condo)
  end
end
