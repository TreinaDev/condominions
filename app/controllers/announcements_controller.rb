class AnnouncementsController < ApplicationController
  before_action :authenticate_manager!, only: %i[update]
  before_action :set_condo, only: %i[new index create]
  before_action :set_announcement, only: %i[show edit update destroy]
  before_action :set_condo_for_details, only: %i[show destroy edit update]
  before_action -> { authorize_condo_manager(@condo) }, only: %i[new create edit update destroy]
  before_action -> { authorize_user(@condo) }, only: %i[show index]
  before_action :set_breadcrumbs_for_action, only: %i[index new create]
  before_action :set_breadcrumbs_for_details, only: %i[show edit update]

  def index
    @announcements = @condo.announcements.order(updated_at: :desc)
  end

  def show; end

  def new
    @announcement = @condo.announcements.new
  end

  def edit; end

  def create
    @announcement = @condo.announcements.new(announcement_params)
    @announcement.manager = current_manager

    unless @announcement.save
      flash.now.alert = t('alerts.announcement.not_created')
      return render 'new', status: :unprocessable_entity
    end

    redirect_to @condo, notice: t('notices.announcement.created')
  end

  def update
    unless @announcement.update(announcement_params)
      flash.now.alert = t('alerts.announcement.not_updated')
      return render 'edit', status: :unprocessable_entity
    end

    redirect_to announcement_path(@announcement), notice: t('notices.announcement.updated')
  end

  def destroy
    redirect_to condo_path(@condo), notice: t('notices.announcement.destroyed') if @announcement.destroy
  end

  private

  def set_breadcrumbs_for_action
    add_breadcrumb @condo.name, condo_path(@condo)
    add_breadcrumb I18n.t("breadcrumb.announcement.#{action_name}")
  end

  def set_breadcrumbs_for_details
    add_breadcrumb @announcement.condo.name, condo_path(@announcement.condo)
    add_breadcrumb @announcement.title, @announcement
  end

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  def set_condo_for_details
    @condo = @announcement.condo
  end

  def set_condo
    @condo = Condo.find params[:condo_id]
  end

  def announcement_params
    params.require(:announcement).permit(:title, :message)
  end
end
