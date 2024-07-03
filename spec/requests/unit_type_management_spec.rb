require 'rails_helper'

describe 'Manager' do
  context 'register unit type' do
    it 'and is not authenticated' do
      condo = create(:condo)

      post(condo_unit_types_path(condo), params: { unit_type: { description: 'Apartamento Duplex',
                                                                metreage: 60, fraction: 3 } })
      expect(response).to redirect_to(new_manager_session_path)
      expect(UnitType.all).to eq []
    end
  end

  context 'edit unit type' do
    it 'and is not authenticated' do
      condo = create(:condo)
      unit_type = create(:unit_type, description: 'Apartamento Duplex')

      patch(condo_unit_type_path(condo, unit_type), params: { unit_type: { description: 'Apartamento Triplex' } })

      expect(response).to redirect_to(new_manager_session_path)
      expect(unit_type.description).to eq 'Apartamento Duplex'
    end
  end
end
