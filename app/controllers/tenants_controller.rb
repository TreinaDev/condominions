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

    @resident.not_owner!
    redirect_to new_resident_owner_path(@resident), notice: t('notices.tenant.updated')
  end

  private

  def set_resident_and_condos
    @resident = Resident.find(params[:resident_id])
    @condos = Condo.all
  end

  def find_tower_and_floor
    tower = Tower.find_by(id: params['resident']['tower_id'])
    return tower.floors[params['resident']['floor'].to_i - 1 ] if tower

    nil
  end

  def find_unit_id
    floor = find_tower_and_floor

    return floor.units[params['resident']['unit'].to_i - 1 ].id if floor

    nil
  end
end
