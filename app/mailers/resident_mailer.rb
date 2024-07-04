class ResidentMailer < ApplicationMailer
  def notify_new_resident
    @resident = params[:resident]
    @token = @resident.send(:set_reset_password_token)
    mail(subject: 'Confirmação de Cadastro', from: 'registration@condo.com', to: @resident.email)
  end
end
