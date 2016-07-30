class ExecutesStripePurchaseJob < ActiveJob::Base

  queue_as :default

  def perform(payment, stripe_token)
    charge_action = ExecutesStripePurchase.new(payment, stripe_token)
    charge_action.run
  end

end
