class ManagersController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create]

  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.new(manager_params)
    if @manager.save
      redirect_to root_path, notice: t('notices.manager.created')
    else
      flash[:alert] = t('alerts.manager.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def manager_params
    params.require(:manager).permit(:full_name, :registration_number, :email, :password)
  end
end
