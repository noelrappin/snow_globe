class PurchasesCartJob < ApplicationJob

  queue_as :default

  def perform(user:, params:, payment_reference:)
    token = StripeToken.new(**card_params(params))
    user.tickets_in_cart.each do |ticket|
      ticket.update(payment_reference: payment_reference)
    end
    purchases_cart_workflow = StripePurchasesCart.new(
        user: user, stripe_token: token,
        purchase_amount_cents: params[:purchase_amount_cents],
        expected_ticket_ids: params[:ticket_ids],
        payment_reference: payment_reference)
    purchases_cart_workflow.run
  end

  def success
    true
  end

  def redirect_on_success_url
    nil
  end

  private def card_params(params)
    params.slice(
        :credit_card_number, :expiration_month,
        :expiration_year, :cvc,
        :stripe_token).symbolize_keys
  end

end
