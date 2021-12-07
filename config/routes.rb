Rails.application.routes.draw do
  resources :account_activation, only: :edit
  mount Base => '/'
end
