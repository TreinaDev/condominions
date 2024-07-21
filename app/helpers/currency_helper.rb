module CurrencyHelper
  def integer_to_brl(value)
    return nil if value.nil?

    ActionController::Base
      .helpers
      .number_to_currency(value / 100.0, unit: 'R$', delimiter: '.', separator: ',')
      .gsub(' ', '')
  end
end
