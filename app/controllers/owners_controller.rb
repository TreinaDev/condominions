class OwnersController < ResidentsController
  before_action :set_resident_and_condos

  def new; end

  def create
    if params[:commit] == 'Finalizar Cadastro'
      if @resident.not_owner?
        random_password = SecureRandom.alphanumeric(8)
        @resident.mail_not_confirmed!
        @resident.send_invitation(random_password)
      end
      return redirect_to root_path, notice: t('notices.owner.finalized')
    end
    unit = Unit.find(find_unit_id)

    if params[:commit] == 'Adicionar Propriedade' && !unit
      flash.now.alert = t('alerts.owner.inexistent_unit')

      return render 'new', status: :unprocessable_entity
    end

    unless @resident.units.include? unit
      @resident.units << unit
      return redirect_to new_resident_owner_path(@resident), notice: t('notices.owner.updated')
    end
    flash.now.alert = t('alerts.owner.duplicated_unit')
    render 'new', status: :unprocessable_entity
  end

  private

  def set_resident_and_condos
    @resident = Resident.find(params[:resident_id])
    @condos = Condo.all
  end

end
