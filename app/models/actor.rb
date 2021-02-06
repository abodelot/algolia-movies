class Actor < ApplicationRecord
  has_and_belongs_to_many :movies, after_add: :index_movies, after_remove: :index_movies

  after_commit :index_movies

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :image, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  private

  # Reindex associated movies so Algolia can keep track of actor modifications
  def index_movies
    movies.reindex!
  end
end
