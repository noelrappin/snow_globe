require "rails_helper"

describe StripeCharge, :vcr do

  let(:token) { StripeToken.new(
<<<<<<< 03829b72767d36f593ad5bed09ab2dbc737eb130
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }
  let(:payment) { build_stubbed(
      :payment, price: Money.new(3000), reference: Payment.generate_reference) }
=======
    credit_card_number: "4242424242424242", expiration_month: "12",
    expiration_year: Time.zone.now.year + 1, cvc: "123") }
  let(:payment) { build_stubbed(
    :payment, price: Money.new(3000), reference: "reference") }
>>>>>>> transfer

  it "calls stripe to get a charge" do
    charge = StripeCharge.charge(token: token, payment: payment)
    expect(charge.id).to start_with("ch")
    expect(charge.amount).to eq(3000)
  end
end
