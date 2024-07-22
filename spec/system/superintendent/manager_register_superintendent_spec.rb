require 'rails_helper'

describe 'Manager register superintendent' do
  it 'Successfully to act now' do
    condo = create :condo, name: 'Condomínio X'
    resident = create(:resident, :with_residence, full_name: 'Alvus Dumbledore', condo:)
    manager = create :manager
    travel_to '2024-07-21'.to_date

    desactive_superintendent_job_spy = spy 'DesactiveSuperintendentJob'
    stub_const 'DesactiveSuperintendentJob', desactive_superintendent_job_spy

    login_as manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Síndico'
    end
    within '#condoSelectPopupForSuperintendent' do
      click_on 'Condomínio X'
    end

    fill_in 'Data de início', with: '2024-07-21'.to_date
    fill_in 'Data de conclusão', with: '2025-07-25'.to_date
    select 'Alvus Dumbledore', from: 'Morador'
    click_on 'Enviar'

    expect(page).to have_content 'Mandato de síndico cadastro com sucesso!'
    expect(current_path).to eq condo_superintendent_path(condo, Superintendent.last)
    expect(Superintendent.last.tenant).to eq resident
    expect(Superintendent.last.in_action?).to eq true
    expect(desactive_superintendent_job_spy).to have_received(:set).with({ wait_until: '2025-07-25'.to_datetime })
  end

  it 'successfully to act on future' do
    condo = create :condo, name: 'Condomínio X'
    resident = create(:resident, :with_residence, full_name: 'Alvus Dumbledore', condo:)
    manager = create :manager
    travel_to '2024-07-21'.to_date

    active_superintendent_job_spy = spy 'ActiveSuperintendentJob'
    stub_const 'ActiveSuperintendentJob', active_superintendent_job_spy

    desactive_superintendent_job_spy = spy 'DesactiveSuperintendentJob'
    stub_const 'DesactiveSuperintendentJob', desactive_superintendent_job_spy

    login_as manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Síndico'
    end
    within '#condoSelectPopupForSuperintendent' do
      click_on 'Condomínio X'
    end
    fill_in 'Data de início', with: '2024-07-25'.to_date
    fill_in 'Data de conclusão', with: '2025-07-21'.to_date
    select 'Alvus Dumbledore', from: 'Morador'
    click_on 'Enviar'

    expect(page).to have_content 'Mandato de síndico cadastro com sucesso!'
    expect(current_path).to eq condo_superintendent_path(condo, Superintendent.last)
    expect(active_superintendent_job_spy).to have_received(:set).with({ wait_until: '2024-07-25'.to_datetime })
    expect(desactive_superintendent_job_spy).to have_received(:set).with({ wait_until: '2025-07-21'.to_datetime })
    expect(Superintendent.last.tenant).to eq resident
    expect(Superintendent.last.pending?).to eq true
  end

  it 'with blank fields' do
    condo = create :condo, name: 'Condomínio X'
    create(:tower, condo:)
    manager = create :manager

    login_as manager, scope: :manager
    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Síndico'
    end
    within '#condoSelectPopupForSuperintendent' do
      click_on 'Condomínio X'
    end
    fill_in 'Data de início', with: ''
    fill_in 'Data de conclusão', with: ''
    click_on 'Enviar'

    expect(page).to have_content 'Não foi possível cadastrar o mandato.'
    expect(page).to have_content 'Data de início não pode ficar em branco'
    expect(page).to have_content 'Data de conclusão não pode ficar em branco'
    expect(page).to have_content 'Morador é obrigatório'
    expect(Superintendent.count).to eq 0
  end

  it 'and condo has superintedent active' do
    condo = create :condo, name: 'Condomínio X'
    superintendent = create(:superintendent, :in_action, condo:)
    resident = superintendent.tenant
    manager = create :manager

    resident.user_image.attach(io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                               filename: 'resident_photo.jpg')

    login_as manager, scope: :manager

    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Síndico'
    end
    within '#condoSelectPopupForSuperintendent' do
      click_on 'Condomínio X'
    end

    expect(current_path).to eq condo_superintendent_path(condo, superintendent)
    expect(page).to have_content 'Esse condomínio já possui um síndico cadastrado!'
  end

  it 'and condo has superintedent in pending' do
    condo = create :condo, name: 'Condomínio X'
    travel_to '2024-07-21'.to_date

    superintendent = create(:superintendent, :pending, condo:, start_date: '2024-07-22'.to_date,
                                                       end_date: '2024-07-25'.to_date)
    resident = superintendent.tenant
    manager = create :manager

    resident.user_image.attach(io: Rails.root.join('spec/support/images/resident_photo.jpg').open,
                               filename: 'resident_photo.jpg')

    login_as manager, scope: :manager

    visit root_path
    within 'nav' do
      click_on id: 'side-menu'
      click_on 'Gerenciar Usuários'
      click_on 'Cadastrar Síndico'
    end
    within '#condoSelectPopupForSuperintendent' do
      click_on 'Condomínio X'
    end

    expect(current_path).to eq condo_superintendent_path(condo, superintendent)
    expect(page).to have_content 'Esse condomínio já possui um síndico cadastrado!'
  end
end
