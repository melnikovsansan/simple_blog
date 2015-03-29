class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to (user_signed_in? ? root_url : new_user_session_path), :alert => exception.message
  end

  def render_alert(e)
    render js: "alert('#{ e.message.gsub '\'', '\\'}')"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :avatar)
    devise_parameter_sanitizer.for(:account_update).push(:first_name, :last_name, :avatar)
  end
end
