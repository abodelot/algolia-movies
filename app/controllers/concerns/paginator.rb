module Paginator
  extend ActiveSupport::Concern

  MAX_PAGE_SIZE = 50
  DEFAULT_PAGE_SIZE = 10

  ##
  # Apply offset and limit on given scope, based on params[:per_page] and params[:page]
  # @param scope: scope to paginate
  # @return scope
  #
  def paginate(scope)
    per_page = params.fetch(:per_page, DEFAULT_PAGE_SIZE).to_i.clamp(1, MAX_PAGE_SIZE)
    page = [params.fetch(:page, 1).to_i, 1].max

    scope.offset((page - 1) * per_page).limit(per_page)
  end
end
