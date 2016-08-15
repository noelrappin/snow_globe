class PurchaseAudit

  include CsvReportable

  attr_accessor :payment, :user

  def self.find_collection
    Payment.includes(:user).succeeded.all.map do |payment|
      PurchaseAudit.new(payment)
    end
  end

  def initialize(payment)
    @payment = payment
    @user = payment.user
  end

  csv do
    column(:reference) { |report| p report; report.payment.reference }
    column(:user_email) { |report| report.user.email }
    column(:user_stripe_id) { |report| report.user.stripe_id }
    column(:price) { |report| report.payment.price }
    column(:total_value) { |report| report.payment.full_value }
  end

end
