class Instrument < ActiveRecord::Base
  has_and_belongs_to_many :measurements, :join_table => 'measurement_instrument'
end
