class AnnouncementsController < ApplicationController
  before_action :set_condo, only: %i[new index create]
  before_action :set_announcement, only: %i[show]
  before_action :set_condo_for_details, only: %i[show]
  before_action -> { authorize_condo_manager!(@condo) }, only: %i[show index new create]

  def index
    @announcements = @condo.announcements
  end

  def show; end

  def new
    @announcement = @condo.announcements.new
  end

  def create
    @announcement = @condo.announcements.new(announcement_params)
    @announcement.manager = current_manager

    unless @announcement.save
      flash.now.alert = t('alerts.announcement.not_created')
      return render 'new', status: :unprocessable_entity
    end

    redirect_to @condo, notice: t('notices.announcement.created')
  end

  private

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
