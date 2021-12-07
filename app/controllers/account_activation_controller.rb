class AccountActivationController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:token])
      user.activate
      render "user_mailer/account_activation_success"
    else
      render "user_mailer/account_activation_failed"
    end
  end
end
