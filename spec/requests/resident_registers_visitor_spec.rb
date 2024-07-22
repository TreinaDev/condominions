require 'rails_helper'

describe 'Resident registers visitor request' do
  context 'POST /residents/:resident_id/visitors' do
    it 'and must be authenticated' do
      resident = create :resident

      post resident_visitors_path(resident), params: { visitor: { full_name: 'João Almeida', identity_number: '12345',
                                                                  visit_date: 1.month.from_now.to_date,
                                                                  category: :visitor } }

      expect(response).to redirect_to new_resident_session_path
    end

    it 'and cannot be authenticated as a manager' do
      resident = create :resident
      manager = create :manager

      login_as manager, scope: :manager
      post resident_visitors_path(resident), params: { visitor: { full_name: 'João Almeida', identity_number: '12345',
                                                                  visit_date: 1.month.from_now.to_date,
                                                                  category: :visitor } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Um administrador não pode administrar visitantes para uma unidade'
    end

    it 'and cannot register a visitor to another resident' do
      tower = create :tower, floor_quantity: 1, units_per_floor: 2
      first_resident = create :resident, residence: tower.floors[0].units[0]
      second_resident = create :resident, residence: tower.floors[0].units[1]

      login_as first_resident, scope: :resident
      post resident_visitors_path(second_resident), params: { visitor: { full_name: 'João Almeida',
                                                                         identity_number: '12345',
                                                                         visit_date: 1.month.from_now.to_date,
                                                                         category: :visitor } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não pode administrar visitantes para outra unidade além da sua'
    end

    it 'only if as a tenant' do
      resident = create :resident

      login_as resident, scope: :resident
      post resident_visitors_path(resident), params: { visitor: { full_name: 'João Almeida', identity_number: '12345',
                                                                  visit_date: 1.month.from_now.to_date,
                                                                  category: :visitor } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Apenas moradores podem administrar visitantes'
    end
  end
end
