class Movie < ApplicationRecord
  include AlgoliaSearch

  # Associations
  has_and_belongs_to_many :actors

  # Validations
  validates :title, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1900, less_than_or_equal_to: 2100 }
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :image, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates_format_of :color, allow_blank: true, with: /\A#\h{6}\z/i # exemple: #3873b2

  # Algolia
  algoliasearch do
    attributes :id, :title, :genres, :year, :score, :rating, :image, :color

    attribute :actors do
      actors.pluck(:name)
    end

    attribute :actor_facets do
      actors.map { |actor| "#{actor.image}|#{actor.name}" }
    end
  end
end
