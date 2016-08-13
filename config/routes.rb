Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root to: "visitors#index"

  # START: user_simulation_routes
  resource :user_simulation, only: %i(create destroy)
  # END: user_simulation_routes

  # START: devise_routes
  devise_for :users, controllers: {
      sessions: "users/sessions"}

  devise_scope :user do
    post "users/sessions/verify" => "Users::SessionsController"
  end
  # END: devise_routes

  resources :events
  resource :shopping_cart
  resource :subscription_cart
  resources :payments
  resources :users
  resources :plans
  resources :subscriptions
  resources :refund

  resource :daily_revenue_report

  get "paypal/approved", to: "pay_pal_payments#approved"

  # START: stripe
  post "stripe/webhook", to: "stripe_webhook#action"
  # END: stripe
end
