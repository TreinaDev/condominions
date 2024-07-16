require 'rails_helper'

describe 'Manager' do
  context 'register visitor entry' do
    it 'and is not authenticated' do
      condo = create(:condo)

      post(condo_visitor_entries_path(condo),
           params: { visitor_entry: { full_name: 'Maria Visitante', identity_number: '124568' } })

      expect(response).to redirect_to(new_manager_session_path)
      expect(VisitorEntry.count).to eq 0
    end
  end
end
