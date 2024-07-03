require 'rails_helper'

describe 'POST /common_areas' do
  it 'must be authenticated to register a common area' do
    condo = create(:condo)

    post condo_common_areas_path(condo), params: { common_area: { name: 'Salão de Festas', max_occupancy: 100,
                                                                  description: 'Realize sua festa em nosso salão',
                                                                  rules: 'Não pode ser utilizado após as 22 horas' } }

    expect(response).to redirect_to(new_manager_session_path)
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end

  it 'must be authenticated to edit a common area' do
    common_area = create(:common_area)

    patch common_area_path(common_area), params: { common_area: { name: 'Churrasqueira', max_occupancy: 30,
                                                                  description: 'Reuna a família em um churrasco',
                                                                  rules: 'Deixe o espaço organizado após o uso' } }

    expect(response).to redirect_to(new_manager_session_path)
    expect(flash[:alert]).to eq 'Para continuar, faça login ou registre-se.'
  end
end
