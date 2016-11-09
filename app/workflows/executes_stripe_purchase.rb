class ExecutesStripePurchase

  attr_accessor :payment, :stripe_token, :stripe_charge

  def initialize(payment, stripe_token)
    @payment = payment
    @stripe_token = StripeToken.new(stripe_token: stripe_token)
  end

  # START: integrate_mailers
  def run
    Payment.transaction do
      result = charge
      result ? on_success : on_failure
    end
  end

  def on_success
    PaymentMailer.notify_success(payment).deliver_later
    NotifyTaxCloudJob.perform_later(payment)
  end

  def on_failure
    unpurchase_tickets
    PaymentMailer.notify_failure(payment).deliver_later
  end
  # END: integrate_mailers

  # START: run_with_exception
  def charge
    raise PreExistingPaymentException if payment.response_id.present?
    @stripe_charge = StripeCharge.new(token: stripe_token, payment: payment)
    @stripe_charge.charge
    payment.update!(@stripe_charge.payment_attributes)
    payment.succeeded?
  end
  # END: run_with_exception

  def unpurchase_tickets
    payment.tickets.each(&:waiting!)
  end

end
