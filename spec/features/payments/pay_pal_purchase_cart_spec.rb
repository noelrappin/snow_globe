require "rails_helper"

describe "purchasing a cart with paypal", :vcr do
  fixtures :all

  it "can add a purchase to a cart" do
    tickets(:midsummer_bums_1).place_in_cart_for(users(:buyer))
    tickets(:midsummer_bums_2).place_in_cart_for(users(:buyer))
    login_as(users(:buyer), scope: :user)
    visit shopping_cart_path
    choose "paypal_radio"
    # click_on "purchase"
  end

end
