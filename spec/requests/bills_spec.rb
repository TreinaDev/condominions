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

    it 'must be authenticated as Resident for that bill to see (other resident)' do
      create :resident, :with_residence
      resident = create :resident, :with_residence
      json_data_details = Rails.root.join('spec/support/json/bill_1_details.json').read
      response_for_unit_one = double('faraday_response', body: json_data_details, success?: true)

      allow(Faraday).to receive(:get).and_return(response_for_unit_one)

      login_as resident, scope: :resident
      get bill_path 1, params: { unit_id: 1 }

      expect(response).to redirect_to root_path
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

    it 'must be authenticated as Resident for that bill to see (other resident)' do
      create :resident, :with_residence
      resident = create :resident, :with_residence
      json_data_details = Rails.root.join('spec/support/json/bill_1_details.json').read
      response_for_unit_one = double('faraday_response', body: json_data_details, success?: true)

      allow(Faraday).to receive(:get).and_return(response_for_unit_one)

      login_as resident, scope: :resident
      get new_bill_receipt_path 1, params: { unit_id: 1 }

      expect(response).to redirect_to root_path
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
    it 'must be authenticated as Resident to post (not authenticated)' do
      post bill_receipts_path 1, params: { image: 'receipt.jpg', bill_id: 1 }

      expect(response).to redirect_to new_resident_session_path
    end

    it 'must be authenticated as Resident to post (authenticated as super manager)' do
      manager = create :manager, is_super: true

      login_as manager, scope: :manager
      post bill_receipts_path 1, params: { image: 'receipt.jpg', bill_id: 1 }

      expect(response).to redirect_to new_resident_session_path
    end

    it 'must be authenticated as Resident for that bill to post (other resident)' do
      create :resident, :with_residence
      resident = create :resident, :with_residence

      login_as resident, scope: :resident
      post bill_receipts_path 1, params: { unit_id: 1, image: 'receipt.jpg', bill_id: 1 }

      expect(response).to redirect_to root_path
    end
  end
end
