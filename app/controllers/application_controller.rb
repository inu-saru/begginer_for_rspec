class ApplicationController < ActionController::API
  rescue_from StandardError, with: :standard_error

  private

  def standard_error(e)
    render status: 400, json: { status: 400, message: "Bad Request: #{e.message}" }
  end
end
