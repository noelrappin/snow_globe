require "rails_helper"

describe "adding a subscription plan to cart" do

  fixtures :all

  it "can add a plan to a cart" do
    login_as(users(:buyer), scope: :user)
    visit plans_path(events(:bums))
    plan = plans(:vip_monthly)
    within("#plan_#{plan.id}") do
      click_on("add-to-cart")
    end
    expect(current_url).to match("cart")
    within("#subscription_#{users(:buyer).subscriptions.last.id}") do
      expect(page).to have_selector(".subtotal", text: "$300")
    end
  end

end
