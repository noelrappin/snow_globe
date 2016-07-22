class PurchasesCart

  attr_accessor :user, :stripe_token, :purchase_amount, :success, :payment

  def initialize(user:, stripe_token:, purchase_amount_cents:)
    @user = user
    @stripe_token = stripe_token
    @purchase_amount = Money.new(purchase_amount_cents)
    @success = false
  end

  def tickets
    @tickets ||= @user.tickets_in_cart
  end

  def run
    Payment.transaction do
      purchase_tickets
      create_payment
      charge
      @success = payment.succeeded?
    end
  end

  def purchase_tickets
    tickets.each(&:purchased!)
  end

  def create_payment
    self.payment = Payment.create!(
      user_id: user.id, price_cents: purchase_amount.cents,
      status: "created", reference: Payment.generate_reference,
      payment_method: "stripe")
    tickets.each do |ticket|
      payment.payment_line_items.create!(
        buyable: ticket, price_cents: ticket.price.cents)
    end
  end

  ## START: code.purchase_charge
  def charge
    charge = StripeCharge.charge(token: stripe_token, payment: payment)
    payment.update(
      status: charge.status, response_id: charge.id,
      full_response: charge.to_json)
  end
  ## END: code.purchase_charge

  delegate :save, to: :payment

end
