class Bill
  attr_accessor :unit_id, :id, :condo_id, :issue_date, :due_date,
                :total_value_cents, :status, :values, :denied, :bill_details

  def initialize(params = {})
    @unit_id = params.fetch('unit_id', nil)
    @id = params.fetch('id', nil)
    @condo_id = params.fetch('condo_id', nil)
    @issue_date = params.fetch('issue_date', nil)
    @due_date = params.fetch('due_date', nil)
    @total_value_cents = params.fetch('total_value_cents', nil)
    @status = params.fetch('status', nil)
    @values = params.fetch('values', [])
    @denied = params.fetch('denied', nil)
    @bill_details = params.fetch('bill_details', [])
  end

  def self.request_open_bills(unit_id)
    response = Faraday.get("http://localhost:4000/api/v1/units/#{unit_id}/bills")

    return [] unless response.success?

    bills_data = JSON.parse(response.body)['bills']
    bills_array = bills_data.map { |bill_data| new(bill_data) }
    bills_array.sort_by { |bill| bill.due_date.to_time.to_i }.reverse
  end

  def self.safe_request_open_bills(unit_id)
    BillService.request_open_bills(unit_id)
  end

  def self.request_bill_details(bill_id)
    response = Faraday.get("http://localhost:4000/api/v1/bills/#{bill_id}")
    return nil unless response.success?

    bill_data = JSON.parse(response.body)
    new(bill_data)
  end

  def total_value_formatted
    "R$ #{format('%.2f', total_value_cents / 100.0).gsub('.', ',')}"
  end

  def self.format_value(value)
    "R$ #{format('%.2f', value / 100.0).gsub('.', ',')}"
  end

  def due_date_formatted
    format_date(@due_date)
  end

  def issue_date_formatted
    format_date(@issue_date)
  end

  private

  def format_date(date)
    Date.parse(date).strftime('%d/%m/%Y')
  end
end
