class PaymentLineItem < ApplicationRecord

  belongs_to :payment
  has_many :buyable, polymorphic: true

end
