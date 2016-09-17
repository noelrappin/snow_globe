class AddsAffiliateAccount

  attr_accessor :user, :affiliate, :success, :tos_checked, :request_ip

  def initialize(user:, tos_checked: nil, request_ip: nil)
    @user = user
    @tos_checked = tos_checked
    @request_ip = request_ip
    @success = false
  end

  def run
    Affiliate.transaction do
      @affiliate = Affiliate.create(
          user: user, country: "US",
          name: user.name, tag: Affiliate.generate_tag)
      @affiliate.update(stripe_id: acquire_stripe_id)
    end
    @success = true
  end

  def acquire_stripe_id
    StripeAccount.new(
        @affiliate, tos_checked: tos_checked, request_ip: request_ip).account.id
  end

  def success?
    @success
  end

end
