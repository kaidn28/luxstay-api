module ResponseHelper
  def render_success_response p_status, format, data, message
    status p_status
    present data, with: format, success: true, message: message
  end
end
