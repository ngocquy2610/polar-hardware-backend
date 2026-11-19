class ApplicationController < ActionController::API
  include Pundit::Authorization # embed Pundit to Controller

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Catch error when user not authorize

  before_action :configure_permitted_parameters,
                if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:full_name, :phone]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:full_name, :phone]
    )
  end
end
