class ResidentMailer < ApplicationMailer
  def notify_new_resident
    @resident = params[:resident]
    @password = params[:password]
    mail(subject: t('resident_mailer.notify_new_resident.subject'), from: 'registration@condo.com', to: @resident.email)
  end
end
