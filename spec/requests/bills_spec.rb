require 'rails_helper'

describe 'Bills/Receipts' do
  context 'GET /bills/{id}' do
    it 'must be authenticated as Resident to see (not authenticated)' do
      get bill_path 1

      expect(response).to redirect_to new_resident_session_path
    end

    it 'must be authenticated as Resident to see (authenticated as super manager)' do
      manager = create :manager, is_super: true

      login_as manager, scope: :manager
      get bill_path 1

      expect(response).to redirect_to new_resident_session_path
    end
  end

  context 'GET /bills/bill_id/receipts/new' do
    it 'must be authenticated as Resident to see (not authenticated)' do
      get new_bill_receipt_path 1

      expect(response).to redirect_to new_resident_session_path
    end

    it 'must be authenticated as Resident to see (authenticated as super manager)' do
      manager = create :manager, is_super: true

      login_as manager, scope: :manager
      get new_bill_receipt_path 1

      expect(response).to redirect_to new_resident_session_path
    end
  end
end
