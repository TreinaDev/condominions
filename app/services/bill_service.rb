class BillService
  def self.request_open_bills(unit_id)
    response = Faraday.get("http://localhost:4000/api/v1/units/#{unit_id}/bills")

    return { bills: [], error: I18n.t('alerts.lost_connection') } unless response.success?

    bills_data = JSON.parse(response.body)['bills']
    bills_array = bills_data.map { |bill_data| Bill.new(bill_data) }
    sorted_bills = bills_array.sort_by { |bill| bill.due_date.to_time.to_i }.reverse

    { bills: sorted_bills, error: nil }
  rescue Faraday::ConnectionFailed
    { bills: [], error: I18n.t('alerts.lost_connection') }
  end
end
