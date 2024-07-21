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

  context 'GET /bills' do
    it 'must be authenticated as Resident to see (not authenticated)' do
      get bills_path

      expect(response).to redirect_to new_resident_session_path
    end

    it 'must be authenticated as Resident to see (authenticated as super manager)' do
      manager = create :manager, is_super: true

      login_as manager, scope: :manager
      get bills_path

      expect(response).to redirect_to new_resident_session_path
    end
  end

  context 'POST /bills/{bill_id}/receipts' do
    it 'must be authenticated as Resident to see (not authenticated)' do
      post bill_receipts_path 1, params: { image: 'receipt.jpg', unid_id: 1 }

      expect(response).to redirect_to new_resident_session_path
    end

    it 'must be authenticated as Resident to see (authenticated as super manager)' do
      manager = create :manager, is_super: true

      login_as manager, scope: :manager
      post bill_receipts_path 1, params: { image: 'receipt.jpg', unid_id: 1 }

      expect(response).to redirect_to new_resident_session_path
    end
  end
end
