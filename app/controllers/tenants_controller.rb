class TenantsController < ResidentsController
  before_action :set_resident_and_condos
  def new; end

  def create
    if params[:commit] == 'Atualizar Morador' && !find_unit_id
      flash.now.alert = t('alerts.tenant.inexistent_unit')

      return render 'new', status: :unprocessable_entity
    end

    unless @resident.update(residence_id: find_unit_id)
      flash.now.alert = t('alerts.tenant.not_updated')

      return render 'new', status: :unprocessable_entity
    end

    @resident.not_owner! if @resident.not_tenant?
    redirect_to new_resident_owner_path(@resident), notice: t('notices.tenant.updated')
  end

  private

  def set_resident_and_condos
    @resident = Resident.find(params[:resident_id])
    @condos = Condo.all
  end

end
