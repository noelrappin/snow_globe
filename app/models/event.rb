class Event < ApplicationRecord

  has_many :performances, dependent: :destroy

end
