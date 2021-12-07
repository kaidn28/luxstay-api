class CouponApi < ApiV1
  namespace :coupon do
    before do
      authenticated
    end

    desc "Get all coupons"

    get "/all" do
      coupons = Coupon.all
      return render_success_response(:ok, CouponResFormat, {data: coupons}, "success") if coupons

      error!(coupons.errors.full_messages[0], :bad_request)
    end

    desc "Apply coupon code"

    params do
      requires :code_name, type: String
    end

    post "/apply" do
      coupon = Coupon.find_by(code_name: params[:code_name])

      return render_success_response(:ok, CouponFormat, coupon, "success") if coupon

      error!("unknow code", :bad_request)
    end
  end
end
