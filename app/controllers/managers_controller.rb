class ManagersController < ApplicationController
  before_action :authenticate_manager!, only: %i[new create]
  before_action :authorize_super_manager, only: %i[new create]
  before_action :set_manager, only: %i[edit_photo update_photo]

  def new
    add_breadcrumb I18n.t('breadcrumb.manager.new')
    @manager = Manager.new
  end

  def create
    add_breadcrumb I18n.t('breadcrumb.manager.new')
    @manager = Manager.new(manager_params)
    if @manager.save
      redirect_to root_path, notice: <<~NOTICE
        Administrador cadastrado com sucesso - Nome: #{@manager.full_name} | Email: #{@manager.email}
      NOTICE
    else
      flash[:alert] = t('alerts.manager.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def edit_photo
    add_breadcrumb I18n.t('breadcrumb.manager.edit_photo')
  end

  def update_photo
    add_breadcrumb I18n.t('breadcrumb.manager.edit_photo')
    return render :edit_photo, status: :unprocessable_entity unless @manager.update(user_image_params)

    redirect_to root_path, notice: I18n.t('notices.manager.updated_photo')
  end

  private

  def set_manager
    @manager = current_manager
  end

  def user_image_params
    params.require(:manager).permit(:user_image)
  end

  def manager_params
    params.require(:manager).permit(:full_name, :registration_number, :email, :password, :user_image, :is_super)
  end
end
