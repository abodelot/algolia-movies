class Api::MoviesController < ApplicationController
  ##
  # Get list of movies
  # @url GET /api/movies
  # @param per_page: number of elements per page (default: 10)
  # @param page: page number (default: 1)
  # @return array of movie objects
  #
  def index
    render json: paginate(Movie)
  end

  ##
  # Get a movie
  # @url GET /api/movies/:id
  # @return movie object
  #
  def show
    render json: Movie.find(params[:id])
  end

  ##
  # Create a new movie
  # @url POST /api/movies
  # @param movie: object attributes
  # @return movie object
  #
  def create
    movie = Movie.create!(movie_params)

    render json: movie
  end

  ##
  # Delete a movie
  # @url DELETE /api/movies/:id
  # @return no content
  #
  def destroy
    Movie.destroy(params[:id])

    head :no_content
  end

  private

  def movie_params
    params.require('movie').permit(
      :title,
      :year,
      :image,
      :rating,
      :score,
      alternative_titles: [],
      genres: [],
    )
  end
end
