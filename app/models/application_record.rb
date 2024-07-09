class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  CPF_REGEX = /\A\d{3}[\.]\d{3}[\.]\d{3}[\-]\d{2}\z/
end
