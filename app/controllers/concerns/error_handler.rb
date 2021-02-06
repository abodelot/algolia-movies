module ErrorHandler
  extend ActiveSupport::Concern

  # These exceptions will be automatically catched, and transformed
  # into an error response with HTTP error code.
  ERRORS = {
    'ActionController::ParameterMissing' => 400,
    'ActiveRecord::RecordInvalid' => 422,
    'ActiveRecord::RecordNotFound' => 404,
  }.freeze

  included do
    ERRORS.each do |klass, status|
      rescue_from(klass, with: -> (error) { render_error(error, status) })
    end
  end

  def render_error(error, status)
    render json: error.as_json, status: status
  end
end
