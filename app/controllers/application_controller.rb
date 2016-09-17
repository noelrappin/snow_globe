class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    return nil if session[:awaiting_authy_user_id].present?
    super
  end

  def current_cart
    ShoppingCart.for(user: current_user)
  end

  # START: simulation_overhead
  def user_for_paper_trail
    simulating_admin_user || current_user
  end

  def simulating_admin_user
    User.find_by(id: session[:admin_id])
  end
  helper_method :simulating_admin_user
  # END: simulation_overhead

  def authenticate_admin_user!
    raise Pundit::NotAuthorizedError unless current_user&.admin?
  end

  # START: affiliate
  before_action :set_affiliate

  def set_affiliate
    tag = params[:tag] || session[:affiliate_tag]
    workflow = AddsAffiliateToCart.new(user: current_user, tag: tag)
    workflow.run
    session[:affiliate_tag] = tag
  end
  # END: affiliate

  private def user_not_authorized
    sign_out(User)
    render plain: "Access Not Allowed", status: :forbidden
  end

end
