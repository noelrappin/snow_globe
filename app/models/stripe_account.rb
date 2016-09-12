class StripeAccount

  attr_accessor :affiliate, :account

  def initialize(affiliate)
    @affiliate = affiliate
  end

  def account
    @account ||= begin
      if affiliate.stripe_id.blank?
        create_account
      else
        retrieve_account
      end
    end
  end

  private def create_account
    Stripe::Account.create(country: affiliate.country, managed: true)
  end

  private def retrieve_account
    Stripe::Account.retrieve(affiliate.stripe_id)
  end

end
