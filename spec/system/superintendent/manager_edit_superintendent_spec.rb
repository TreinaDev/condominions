require 'rails_helper'

describe 'Manager edit superintendent' do
  it 'succesfully' do
    condo = create :condo, name: 'Condomínio X'
    resident = create(:resident, :with_residence, full_name: 'Dona Alvara', condo:)
    resident2 = create(:resident, :with_residence, full_name: 'Havana Silva', email: 'email@email.com', condo:)
    superintendent = create(:superintendent, tenant: resident, condo:)

    manager = create :manager

    resident.user_image.attach(io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                               filename: 'resident_photo.jpg')

    login_as manager, scope: :manager
    visit condo_path condo
    click_on 'Dona Alvara'
    click_on 'Editar Síndico'
    fill_in 'Data de conclusão', with: Time.zone.today >> 30
    select 'Havana Silva', from: 'Morador'
    click_on 'Enviar'

    superintendent.reload
    expect(page).to have_content 'Mandato de síndico atualizado com sucesso!'
    expect(current_path).to eq condo_superintendent_path(condo, Superintendent.last)
    expect(superintendent.end_date).to eq Time.zone.today >> 30
    expect(superintendent.tenant).to eq resident2
    expect(resident.superintendent).to eq nil
  end

  it 'with missing params' do
    condo = create :condo, name: 'Condomínio X'
    resident = create(:resident, :with_residence, full_name: 'Dona Alvara', condo:)
    create(:superintendent, tenant: resident, condo:, start_date: Time.zone.today, end_date: Time.zone.today >> 2)
    manager = create :manager

    resident.user_image.attach(io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                               filename: 'resident_photo.jpg')

    login_as manager, scope: :manager
    visit condo_path condo
    click_on 'Dona Alvara'
    click_on 'Editar Síndico'
    fill_in 'Data de conclusão', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível atualizar o mandato.'
    expect(Superintendent.last.end_date).to eq Time.zone.today >> 2
  end
end
