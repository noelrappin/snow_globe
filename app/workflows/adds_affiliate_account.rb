class AddsAffiliateAccount

  attr_accessor :user, :affiliate, :success

  def initialize(user:)
    @user = user
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
    StripeAccount.new(@affiliate).account.id
  end

  def success?
    @success
  end

end
