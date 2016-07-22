require "rails_helper"

describe ShoppingCartsController do

  describe "update" do
    let(:user) { instance_spy(User) }
    let(:inventory) { instance_spy(Inventory, event: "event_path") }
    let(:action) { instance_spy(AddsToCart) }

    before(:example) do
      allow(@controller).to receive(:current_user).and_return(user)
      allow(Inventory).to receive(:find).with("2").and_return(inventory)
      allow(AddsToCart).to receive(:new).with(
        inventory: inventory, count: "1", user: user).and_return(action)
    end

    it "calls add to cart on a successful" do
      allow(action).to receive(:result).and_return(true)
      patch :update, inventory_id: "2", ticket_count: "1"
      expect(action).to have_received(:run)
      expect(@controller).to redirect_to(shopping_cart_path)
    end

    it "redirects back to the event if unsuccessful" do
      allow(action).to receive(:result).and_return(false)
      patch :update, inventory_id: "2", ticket_count: "1"
      expect(action).to have_received(:run)
      expect(@controller).to redirect_to(inventory.event)
    end
  end

end
