class TenantsController < ResidentsController
  before_action :set_resident_and_condos
  def new; end

  def create
    unless params[:commit] == 'Não reside neste condomínio'
      unit = find_unit_id
      unless unit
        flash.now.alert = t('alerts.tenant.inexistent_unit')

        return render 'new', status: :unprocessable_entity
      end

      unless @resident.update(residence_id: unit)
        flash.now.alert = t('alerts.tenant.not_updated')

        return render 'new', status: :unprocessable_entity
      end
    end

    if @resident.not_tenant?
      @resident.mail_not_confirmed!
      random_password = SecureRandom.alphanumeric(8)
      @resident.update(password: random_password)
      @resident.send_invitation(random_password)
    end

    redirect_to root_path, notice: t('notices.tenant.updated')
  end

  # def create
  #   if params[:commit] == 'Atualizar Morador' && !find_unit_id
  #     flash.now.alert = t('alerts.tenant.inexistent_unit')

  #     return render 'new', status: :unprocessable_entity
  #   end

  #   unless @resident.update(residence_id: find_unit_id)
  #     flash.now.alert = t('alerts.tenant.not_updated')

  #     return render 'new', status: :unprocessable_entity
  #   end

  #   @resident.not_owner! if @resident.not_tenant?
  #   redirect_to new_resident_owner_path(@resident), notice: t('notices.tenant.updated')
  # end

  private

  def set_resident_and_condos
    @resident = Resident.find(params[:resident_id])
    @condos = Condo.all
  end

end
