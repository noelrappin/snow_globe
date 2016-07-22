require "rails_helper"

describe StripeToken, :vcr do

  it "calls stripe to get a token" do
    token = StripeToken.new(
<<<<<<< 03829b72767d36f593ad5bed09ab2dbc737eb130
        credit_card_number: "4242424242424242", expiration_month: "12",
        expiration_year: Time.zone.now.year + 1, cvc: "123")
=======
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123")
>>>>>>> transfer
    expect(token.id).to start_with("tok_")
  end

end
