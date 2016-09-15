class StripeAccount

  attr_accessor :affiliate, :account, :tos_checked, :request_ip

  def initialize(affiliate, tos_checked:, request_ip:)
    @affiliate = affiliate
    @tos_checked = tos_checked
    @request_ip = request_ip
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
    account_params = {country: affiliate.country, managed: true}
    if tos_checked
      account_params[:tos_acceptance] = {date: Time.now.to_i, ip: request_ip}
    end
    Stripe::Account.create(account_params)
  end

  private def retrieve_account
    Stripe::Account.retrieve(affiliate.stripe_id)
  end

end
