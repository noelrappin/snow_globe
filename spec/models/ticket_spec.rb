require "rails_helper"

RSpec.describe Ticket, type: :model do

<<<<<<< 03829b72767d36f593ad5bed09ab2dbc737eb130
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:performance) { create(:performance, event: event) }

  it "can move to waiting" do
    ticket = create(:ticket, status: "unsold", performance: performance)
=======
  it "can move to waiting" do
    user = create(:user)
    ticket = create(:ticket, status: "unsold")
>>>>>>> transfer
    ticket.place_in_cart_for(user)
    expect(ticket.user).to eq(user)
    expect(ticket.status).to eq("waiting")
  end

  it "can move to purchased" do
<<<<<<< 03829b72767d36f593ad5bed09ab2dbc737eb130
    ticket = create(
        :ticket, status: "waiting",
                 user: user, performance: performance)
    ticket.purchased!
=======
    user = create(:user)
    ticket = create(:ticket, status: "waiting", user: user)
    ticket.purchase
>>>>>>> transfer
    expect(ticket.user).to eq(user)
    expect(ticket.status).to eq("purchased")
  end
end
