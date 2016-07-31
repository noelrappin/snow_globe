require "rails_helper"

describe "purchasing a subscription plan", :vcr do

  fixtures :all

  let(:plan) { plans(:vip_monthly) }
  let!(:subscription) { Subscription.create(
      user: users(:buyer), plan: plan,
      start_date: Time.zone.now.to_date,
      end_date: plan.end_date_from, status: :waiting) }
  let(:token) { StripeToken.new(
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }

  it "can add a plan to a cart" do
    login_as(users(:buyer), scope: :user)
    visit subscription_cart_path
    choose "credit_radio"
    find("#spec_stripe_token", visible: false).set(token.id)
    click_on "purchase"
    visit user_path(users(:buyer))
    users(:buyer).reload
    subscription.reload
    expect(users(:buyer).stripe_id).not_to be_nil
    expect(subscription).to be_pending_initial_payment
  end

end
