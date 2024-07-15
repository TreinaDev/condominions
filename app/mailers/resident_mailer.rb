class ResidentMailer < ApplicationMailer
  def notify_new_resident
    @resident = params[:resident]
    @token, hashed = Devise.token_generator.generate(Resident, :reset_password_token)
    @resident.reset_password_token = hashed
    @resident.reset_password_sent_at = Time.now.utc
    @resident.save
    mail(subject: t('resident_mailer.notify_new_resident.subject'), from: 'registration@condo.com', to: @resident.email)
  end
end
