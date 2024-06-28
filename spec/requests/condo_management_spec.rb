require 'rails_helper'

describe 'Manager' do
  context 'register condo' do
    it 'and is not authenticated' do
      post(condos_path, params: { condo: { name: 'Condominio Residencial Paineiras',
                                           registration_number: '38.352.640/0001-33' } })
      expect(response).to redirect_to(new_manager_session_path)
      expect(Condo.all).to eq []
    end
  end

  context 'edit condo' do
    it 'and is not authenticated' do
      condo = create(:condo, name: 'Condominio Criado')

      patch(condo_path(condo), params: { condo: { name: 'Condominio Editado' } })

      expect(response).to redirect_to(new_manager_session_path)
      expect(condo.name).to eq 'Condominio Criado'
    end
  end
end
