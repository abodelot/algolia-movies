class ApplicationController < ActionController::Base
  include ErrorHandler
  include Paginator
end
