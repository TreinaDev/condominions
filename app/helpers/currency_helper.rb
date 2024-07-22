module CurrencyHelper
  def integer_to_brl(value)
    return nil unless value

    ActionController::Base.helpers.number_to_currency(
      value / 100.0,
      unit: 'R$',
      delimiter: '.',
      separator: ','
    ).delete(' ')
  end
end
