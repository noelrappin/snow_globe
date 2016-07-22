class StripeCharge

  attr_accessor :token, :payment, :response

  def self.charge(token:, payment:)
    StripeCharge.new(token: token, payment: payment).charge
  end

  def initialize(token:, payment:)
    @token = token
    @payment = payment
  end

  def charge
    return if response.present?
    @response = Stripe::Charge.create(
      {amount: payment.price.cents, currency: "usd",
          source: token.id, description: "", 
          metadata: {reference: payment.reference}},
      idempotency_key: payment.reference)
  end

end
