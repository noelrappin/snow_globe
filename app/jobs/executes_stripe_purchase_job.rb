class ExecutesStripePurchaseJob < ActiveJob::Base

  queue_as :default

  rescue_from(PreExistingPaymentException) do |exception|
    Rollbar.error(exception)
  end

  def perform(payment, stripe_token)
    charge_action = ExecutesStripePurchase.new(payment, stripe_token)
    charge_action.run
  end

end
