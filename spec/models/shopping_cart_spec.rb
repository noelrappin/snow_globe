require "rails_helper"

describe ShoppingCart do

  let(:cart) { ShoppingCart.new(user) }

  let(:user) { instance_double("User") }
  let(:romeo) { instance_double("Event", name: "Romeo and Juliet") }
  let(:hamlet) { instance_double("Event", name: "Hamlet") }
  let(:romeo_performance) { instance_spy("Performance", id: 1, event: romeo) }
  let(:hamlet_performance) { instance_spy("Performance", id: 2, event: hamlet) }
  let(:t1) { instance_double(
      "Ticket", event: romeo,
                performance: romeo_performance, price: Money.new(1500)) }
  let(:t2) { instance_double(
      "Ticket", event: romeo,
                performance: romeo_performance, price: Money.new(1500)) }
  let(:t3) { instance_double(
      "Ticket", event: hamlet,
                performance: hamlet_performance, price: Money.new(1500)) }

  before(:example) do
    allow(user).to receive(:tickets_in_cart).and_return([t1, t2, t3])
  end

  it "retrieves a list of events" do
    expect(cart.events.map(&:name)).to eq(["Hamlet", "Romeo and Juliet"])
  end

  it "retrieves a histogram of performances" do
    expect(cart.performance_count).to match(1 => 2, 2 => 1)
  end

  it "gets performances for event" do
    expect(cart.performances_for(romeo)).to eq([romeo_performance])
  end

  it "calculates fee" do
    expect(cart.processing_fee).to eq(Money.new(100))
  end

  it "calculates entire total" do
    expect(cart.total_cost).to eq(Money.new(4600))
  end

end
