require 'rails_helper'

context 'POST /announcements' do
  it 'must be authenticated to register an announcement' do
    condo = create :condo

    post condo_announcements_path condo, params: { announcement: { title: 'Novo Aviso' } }

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
  end

  it 'and he´s not associated or is not a super' do
    condo_manager = create :manager, is_super: false
    condo = create :condo

    login_as condo_manager, scope: :manager
    post condo_announcements_path condo, params: { announcement: { title: 'Novo Aviso' } }

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
  end
end
