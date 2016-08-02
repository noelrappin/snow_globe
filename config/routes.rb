Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root to: "visitors#index"
  devise_for :users
  resources :events
  resource :shopping_cart
  resource :subscription_cart
  resources :payments
  resources :users
  resources :plans
  resources :subscriptions
  resources :refund

  get "paypal/approved", to: "pay_pal_payments#approved"

  # START: stripe
  post "stripe/webhook", to: "stripe_webhook#action"
  # END: stripe
end
