class PreparesCart

  # START: with_codes
  attr_accessor :user, :purchase_amount_cents,
      :purchase_amount, :success,
      :payment, :expected_ticket_ids,
      :payment_reference, :shopping_cart

  def initialize(user: nil, purchase_amount_cents: nil,
      expected_ticket_ids: "", payment_reference: nil,
      shopping_cart: nil)
    @user = user
    @shopping_cart = shopping_cart
    @purchase_amount = Money.new(purchase_amount_cents)
    @success = false
    @continue = true
    @expected_ticket_ids = expected_ticket_ids.split(" ").map(&:to_i).sort
    @payment_reference = payment_reference || Payment.generate_reference
  end

  delegate :discount_code, to: :shopping_cart

  def price_calculator
    @price_calculator ||= PriceCalculator.new(
        tickets, discount_code, shopping_cart.shipping_method)
  end

  delegate :total_price, to: :price_calculator
  # END: with_codes

  # START: admin_valid
  def amount_valid?
    return true if user.admin?
    purchase_amount == total_price
  end

  def tickets_valid?
    expected_ticket_ids == tickets.map(&:id).sort
  end

  def pre_purchase_valid?
    amount_valid? && tickets_valid?
  end
  # END: admin_valid

  def tickets
    @tickets ||= @user.tickets_in_cart.select do |ticket|
      ticket.payment_reference == payment_reference
    end
  end

  def existing_payment
    Payment.find_by(reference: payment_reference)
  end

  # START: code_payment_attributes
  def run
    Payment.transaction do
      raise PreExistingPurchaseException.new(purchase) if existing_payment
      raise ChargeSetupValidityException.new(
          user: user,
          expected_purchase_cents: purchase_amount.to_i,
          expected_ticket_ids: expected_ticket_ids) unless pre_purchase_valid?
      update_tickets
      create_payment
      clear_cart
      on_success
    end
  rescue
    on_failure
    raise
  end

  def clear_cart
    shopping_cart.destroy
  end

  def payment_attributes
    {user_id: user.id, price_cents: purchase_amount.cents,
     status: "created", reference: Payment.generate_reference,
     discount_code_id: discount_code&.id,
     partials: price_calculator.breakdown,
     shipping_method: shopping_cart.shipping_method,
     shipping_address: shopping_cart.address}
  end
  # END: code_payment_attributes

  def redirect_on_success_url
    nil
  end

  def create_payment
    self.payment = existing_payment || Payment.new
    payment.update!(payment_attributes)
    payment.create_line_items(tickets)
    @success = payment.valid?
  end

  def success?
    success
  end

  def unpurchase_tickets
    tickets.each(&:waiting!)
  end

end
