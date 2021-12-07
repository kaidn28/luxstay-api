module AuthHelper
  def set_cookie token
    cookies[:token] = {
      value: token,
      expires: Settings.expire_token_time.years.from_now,
      path: "/api/v1",
      secure: Rails.env.production?,
      httponly: Rails.env.production?
    }
  end

  def encode_token payload
    JWT.encode payload, ENV["SECRET_KEY"], ENV["JWT_ALGORITHM"]
  end

  def decode_token
    return unless auth_header

    token = auth_header
    begin
      JWT.decode(token, ENV["SECRET_KEY"], true, algorithm: ENV["JWT_ALGORITHM"])
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    return unless decode_token

    user_id = decode_token[0]["user_id"]
    user = User.find_by id: user_id
    error!(I18n.t("request.login"), :unauthorized) unless user
    user
  end

  def auth_header
    token = request.headers["Authorization"] || cookies[:token]
    error!(I18n.t("errors.auth_token_not_found"), :unauthorized) unless token
    token
  end

  def admin_authenticated
    error!("Admin Unauthorized", :unauthorized) unless current_user.admin?
  end

  def authenticated
    error!(I18n.t("request.login"), :unauthorized) unless logged_in?
  end

  private

  def logged_in?
    current_user.present?
  end
end
