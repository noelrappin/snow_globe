class AddsToCart

  attr_accessor :user, :performance, :count, :success, :cart

  def initialize(user:, performance:, count:)
    @user = user
    @performance = performance
    @count = count.to_i
    @success = false
    @cart = ShoppingCart.for(user: user)
  end

  def run
    Ticket.transaction do
      tickets = performance.unsold_tickets(count)
      return if tickets.size != count
      tickets.each { |ticket| ticket.place_in_cart_for(user) }
      self.success = tickets.all?(&:valid?)
      success
    end
  end

end
