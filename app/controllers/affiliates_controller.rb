class AffiliatesController < ApplicationController

  def new

  end

  def show
    @affiliate = Affiliate.find(params[:id])
  end

  def create
    workflow = AddsAffiliateAccount.new(
        user: current_user, tos_checked: params[:tos],
        request_ip: request.remote_ip)
    workflow.run
    if workflow.success
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

end
