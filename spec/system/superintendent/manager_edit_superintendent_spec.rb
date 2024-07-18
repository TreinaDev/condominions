require 'rails_helper'

describe 'Manager edit superintendent' do
  it 'succesfully' do
    condo = create :condo, name: 'Condomínio X'
    tower = create(:tower, condo:)
    unit11 = tower.floors.first.units.first
    unit12 = tower.floors.first.units[1]
    resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
    resident2 = create :resident, full_name: 'Havana Silva', residence: unit12, email: 'havana@email.com'
    superintendent = create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                                             end_date: Time.zone.today >> 2)
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
    expect(current_path).to eq superintendent_path Superintendent.last
    expect(superintendent.end_date).to eq Time.zone.today >> 30
    expect(superintendent.tenant).to eq resident2
    expect(resident.superintendent).to eq nil
  end

  it 'with missing params' do
    condo = create :condo, name: 'Condomínio X'
    tower = create(:tower, condo:)
    unit11 = tower.floors.first.units.first
    resident = create :resident, full_name: 'Dona Alvara', residence: unit11, email: 'alvara@email.com'
    create(:superintendent, condo:, tenant: resident, start_date: Time.zone.today,
                            end_date: Time.zone.today >> 2)
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
