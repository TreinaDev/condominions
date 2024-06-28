require 'rails_helper'

describe 'Manager' do
  context 'register condo' do
    it 'and is not authenticated' do
      post(condos_path, params: { condo: { name: 'Condominio Residencial Paineiras',
                                           registration_number: '38.352.640/0001-33' } })
      expect(response).to redirect_to(new_manager_session_path)
    end
  end

  context 'edit condo' do
    it 'and is not authenticated' do
      condo = create(:condo)

      patch(condo_path(condo), params: { condo: { name: 'Condominio Residencial Paineiras',
                                                  registration_number: '38.352.640/0001-33' } })

      expect(response).to redirect_to(new_manager_session_path)
    end
  end
end
