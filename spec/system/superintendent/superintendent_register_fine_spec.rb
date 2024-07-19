require 'rails_helper'

describe 'Superintendent register fine' do
  it 'successful' do
    condo = create :condo, name: 'Condomínio X'
    tower = create(:tower, name: 'Torre X', floor_quantity: 3, units_per_floor: 2, condo:)
    unit11 = tower.floors[0].units[0]
    unit22 = tower.floors[1].units[1]
    create :resident, properties: [unit22], residence: unit22, email: 'fernando@email.com'
    resident_super = create :resident, residence: unit11, email: 'alvara@email.com'
    create(:superintendent, condo:, tenant: resident_super, start_date: Time.zone.today,
                            end_date: Time.zone.today >> 2)

    login_as resident_super, scope: :resident

    visit root_path
    click_on 'Condomínio X'
    click_on 'Lançar Multa'

    within '#form_data' do
      select 'Torre X',	from: 'Torre'
      select '2',	from: 'Andar'
      select '2',	from: 'Unidade'
      fill_in 'Valor', with: 50_000
      fill_in 'Descrição', with: 'Som alto'
      click_on 'Lançar Multa'
    end

    expect(current_path).to eq condo_path condo
    expect(page).to have_content 'Multa lançada com sucesso para a Unidade 22'
    expect(SingleCharge.last.unit).to eq unit22
    expect(SingleCharge.last.value_cents).to eq 50_000
  end

  it 'with missing params' do
    condo = create :condo, name: 'Condomínio X'
    tower = create(:tower, name: 'Torre X', floor_quantity: 3, units_per_floor: 2, condo:)
    unit11 = tower.floors[0].units[0]
    unit22 = tower.floors[1].units[1]
    create :resident, properties: [unit22], residence: unit22, email: 'fernando@email.com'
    resident_super = create :resident, residence: unit11, email: 'alvara@email.com'
    create(:superintendent, condo:, tenant: resident_super, start_date: Time.zone.today,
                            end_date: Time.zone.today >> 2)

    login_as resident_super, scope: :resident

    visit root_path
    click_on 'Condomínio X'
    click_on 'Lançar Multa'

    within '#form_data' do
      fill_in 'Valor', with: ''
      fill_in 'Descrição', with: ''
      click_on 'Lançar Multa'
    end

    expect(page).to have_content 'Não foi possível lançar a multa'
    expect(page).to have_content 'Valor não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(SingleCharge.last).to eq nil
  end

  it 'to a unit that has no owner' do
    condo = create :condo, name: 'Condomínio X'
    tower = create(:tower, name: 'Torre X', floor_quantity: 3, units_per_floor: 2, condo:)
    unit11 = tower.floors[0].units[0]
    resident_super = create :resident, residence: unit11
    create(:superintendent, condo:, tenant: resident_super, start_date: Time.zone.today,
                            end_date: Time.zone.today >> 2)

    login_as resident_super, scope: :resident

    visit root_path
    click_on 'Condomínio X'
    click_on 'Lançar Multa'

    within '#form_data' do
      select 'Torre X',	from: 'Torre'
      select '2',	from: 'Andar'
      select '2',	from: 'Unidade'
      fill_in 'Valor', with: 50_000
      fill_in 'Descrição', with: 'Som alto'
      click_on 'Lançar Multa'
    end

    expect(page).to have_content 'Não foi possível lançar a multa'
    expect(page).to have_content 'Não há proprietário para a unidade selecionada'
    expect(SingleCharge.last).to eq nil
  end

  it 'is not authenticated as a superintendent' do
    condo = create :condo, name: 'Condomínio X'
    tower = create(:tower, name: 'Torre X', floor_quantity: 3, units_per_floor: 2, condo:)
    unit11 = tower.floors[0].units[0]
    resident = create :resident, residence: unit11

    login_as resident, scope: :resident

    visit root_path
    click_on 'Condomínio X'

    expect(page).not_to have_link 'Lançar Multa'
  end

  it 'is authenticated as a manager' do
    create :condo, name: 'Condomínio X'
    manager = create :manager

    login_as manager, scope: :manager

    visit root_path
    click_on 'Condomínio X'

    expect(page).not_to have_link 'Lançar Multa'
  end
end
