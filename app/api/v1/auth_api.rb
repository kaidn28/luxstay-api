class AuthApi < ApiV1
  namespace :auth do
    desc "Sign up"
    params do
      requires :name, type: String, message: I18n.t("messages.errors.required")
      optional :gender, type: Symbol, values: [:male, :female, :other]
      requires :email, type: String, message: I18n.t("messages.errors.required")
      requires :phone, type: String,
        regexp: {value: /(09|01[2|6|8|9])+([0-9]{8})\b/, message: I18n.t("messages.errors.invalid_phone_number")}
      requires :password, type: String, message: I18n.t("messages.errors.required")
      requires :password_confirmation, type: String, same_as: :password, message: I18n.t("messages.errors.required")
    end
    post "/signup" do
      data = valid_params(params, User::SIGN_UP_PARAMS)
      user = User.create data
      if user.valid?
        user.send_activation_email
        return render_success_response(:ok, MessageFormat, {user: user}, I18n.t("messages.warning.activate_account"))
      end

      error!(user.errors.full_messages[0], :bad_request)
    end

    desc "Sign in"
    params do
      requires :email, type: String, message: I18n.t("messages.errors.required")
      requires :password, type: String, message: I18n.t("messages.errors.required")
    end
    post "/signin" do
      @user = get_user_by_email

      error!(I18n.t("messages.errors.email_not_found"), :bad_request) unless @user

      unless @user.activated?
        return render_success_response(:ok, MessageFormat, {user: @user}, I18n.t("messages.warning.activate_account"))
      end

      if @user&.authenticate params[:password]
        token = encode_token({user_id: @user.id})
        set_cookie token
        return render_success_response(:ok, AuthFormat, {token: token, user: @user}, I18n.t("messages.success.login"))
      else
        error!(I18n.t("messages.errors.incorrect_password"), :bad_request)
      end
    end
  end
end
