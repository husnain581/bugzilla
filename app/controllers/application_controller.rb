# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # application_controller
  include Pundit::Authorization
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(_resource)
    projects_path
  end

  def after_sign_out_path_for(_resource)
    root_path
  end

  def not_found
    redirect_to '/404'
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: projects_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name user_type email password])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[name user_type email password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name user_type email password])
  end
end
