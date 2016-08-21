class DayRevenueReport < SimpleDelegator

  include CsvReportable

  attr_accessor :date, :revenue, :discounts

  def self.find_collection
    result = DayRevenue.all.map { |dr| DayRevenueReport.new(dr) }
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
