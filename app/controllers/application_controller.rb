class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  def render_error(status, errors)
    render json: { errors: errors}, status: status
  end
end
