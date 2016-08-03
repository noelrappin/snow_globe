class Event < ApplicationRecord

  has_paper_trail

  has_many :performances, dependent: :destroy

end
