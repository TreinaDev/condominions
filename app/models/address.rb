class Address < ApplicationRecord
  STATES = ["AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MS","MT","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"]
  has_one :condo

  validates :public_place, :number, :neighborhood, :city, :state, :zip, presence: true
  validates :zip, numericality: { greater_than: 0 }
  validates :zip, length: { is: 8 }

end
