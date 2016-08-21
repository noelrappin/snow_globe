class DayRevenueReport < SimpleDelegator

  include CsvReportable

  attr_accessor :date, :revenue, :discounts

  def self.find_collection
    result = DayRevenue.all.map { |dr| DayRevenueReport.new(dr) }
    ActiveRecord::Base.connection.select_all(
        %{SELECT date(created_at) as day,
        sum(price_cents) as price_cents,
        sum(discount_cents) as discounts_cents
        FROM "payments"
        WHERE "payments"."status" = 1
        GROUP BY date(created_at)
        HAVING date(created_at) < '#{1.day.ago.to_date}'}).map do |data|

      DayRevenue.create(data)
    end
    DayRevenue.all.each do |day_revenue|
      tickets = PaymentLineItem.tickets.no_refund
          .where("date(created_at) = ?", day_revenue.day).count
      day_revenue.update(ticket_count: tickets)
    end
    result << DayRevenue.build_for(Date.yesterday)
    result << DayRevenue.build_for(Date.current)
    result.sort_by(&:day)
  end

  def initialize(day_revenue)
    super(day_revenue)
  end

  csv do
    column(:day)
    column(:price)
    column(:discounts)
    column(:ticket_count)
  end

end
