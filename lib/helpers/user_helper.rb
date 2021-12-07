module UserHelper
  def get_user_by_email
    @user = User.find_by email: params[:email]
  end
end
