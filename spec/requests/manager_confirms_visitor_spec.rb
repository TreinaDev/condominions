require 'rails_helper'

describe 'Manager confirms visitor' do
  context 'POST /visitor/:id/confirm' do
    it 'only if authenticated' do
      visitor = create :visitor

      post confirm_entry_visitor_path(visitor)

      expect(response).to redirect_to new_manager_session_path
      expect(visitor.reload.confirmed?).to eq false
    end

    it 'only if manager' do
      visitor = create :visitor
      resident = create :resident

      login_as resident, scope: :resident
      post confirm_entry_visitor_path(visitor)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
      expect(visitor.reload.confirmed?).to eq false
    end

    it 'cannot if not associated with condo' do
      manager = create :manager, is_super: false
      visitor = create :visitor

      login_as manager, scope: :manager
      post confirm_entry_visitor_path(visitor)

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'Você não possui autorização para essa ação'
      expect(visitor.reload.confirmed?).to eq false
    end

    it 'successfully only if associated with the condo' do
      manager = create :manager, is_super: false
      visitor = create :visitor, visit_date: Time.zone.today
      manager.condos << visitor.condo

      login_as manager, scope: :manager
      post confirm_entry_visitor_path(visitor)

      expect(response).to redirect_to find_condo_visitors_path(visitor.condo)
      expect(flash[:notice]).to eq 'Entrada do visitante registrada com sucesso.'
      expect(visitor.reload.confirmed?).to be_truthy
    end

    it 'only if visitor not confirmed' do
      manager = create :manager
      visitor = create :visitor, :confirmed

      login_as manager, scope: :manager
      post confirm_entry_visitor_path(visitor)

      expect(response).to redirect_to find_condo_visitors_path(visitor.condo)
      expect(flash[:alert]).to eq 'Essa entrada já foi confirmada antes ou não é referente ao dia de hoje'
      expect(VisitorEntry.count).to eq 0
    end

    context 'visit_date ' do
      it 'cannot be past' do
        manager = create :manager
        visitor = create :visitor, visit_date: Time.zone.today

        login_as manager, scope: :manager
        travel_to 1.day.from_now do
          post confirm_entry_visitor_path(visitor)

          expect(response).to redirect_to find_condo_visitors_path(visitor.condo)
          expect(flash[:alert]).to eq 'Essa entrada já foi confirmada antes ou não é referente ao dia de hoje'
          expect(visitor.reload.confirmed?).to eq false
        end
      end

      it 'cannot be future' do
        manager = create :manager
        visitor = create :visitor, visit_date: 1.day.from_now

        login_as manager, scope: :manager
        post confirm_entry_visitor_path(visitor)

        expect(response).to redirect_to find_condo_visitors_path(visitor.condo)
        expect(flash[:alert]).to eq 'Essa entrada já foi confirmada antes ou não é referente ao dia de hoje'
        expect(visitor.reload.confirmed?).to eq false
      end
    end
  end
end
