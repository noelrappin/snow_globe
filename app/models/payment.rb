class Payment < ActiveRecord::Base

  include HasReference

  belongs_to :user
  has_many :payment_line_items
  has_many :tickets, through: :payment_line_items,
                     source_type: "Ticket", source: "buyable"

  monetize :price_cents

  enum status: [:created, :succeeded]

  def total_cost
    tickets.map(&:price).sum
  end

end
