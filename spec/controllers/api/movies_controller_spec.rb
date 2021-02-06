require 'rails_helper'

RSpec.describe Api::MoviesController do
  before do
    @movie = FactoryBot.create(:movie)
  end

  describe 'GET index' do
    it 'returns movie list' do
      get :index

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json.dig(0, 'id')).to eq @movie.id
    end

    it 'paginates movie list' do
      FactoryBot.create_list(:movie, 20)

      get :index
      json = JSON.parse(response.body)
      expect(json.size).to eq 10

      get :index, params: { per_page: 20 }
      json = JSON.parse(response.body)
      expect(json.size).to eq 20

      get :index, params: { per_page: 30 }
      json = JSON.parse(response.body)
      expect(json.size).to eq 21 # only 21 available
    end
  end

  describe 'GET show' do
    it 'returns given movie' do
      get :show, params: { id: @movie.id }

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['id']).to eq @movie.id
    end

    it 'returns 404 error when id is invalid' do
      get :show, params: { id: 0 }
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST create' do
    let(:params) do
      {
        movie: {
          title: 'Batman',
          alternative_titles: ["L'homme chauve-souris"],
          genres: %w[Action Aventure],
          image: 'https://cdn.com/pic/batman.jpg',
          year: 2005,
          rating: 4,
          score: 7.4,
        },
      }
    end

    it 'creates a new movie' do
      post :create, params: params

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(Movie.last.id).to eq json['id']
      expect(Movie.last.title).to eq 'Batman'
      expect(Movie.last.alternative_titles).to eq ["L'homme chauve-souris"]
    end

    it 'returns error if payload is missing' do
      post :create, params: { foobar: :foobaz }

      expect(response).to have_http_status(400)
    end

    it 'returns error if title is missing' do
      params[:movie].delete(:title)
      post :create, params: params

      expect(response).to have_http_status(422)
    end

    it 'returns error if year is not in range' do
      params[:movie][:year] = 2400
      post :create, params: params

      expect(response).to have_http_status(422)
    end

    it 'returns error if rating is not in range' do
      params[:movie][:rating] = -1
      post :create, params: params

      expect(response).to have_http_status(422)
    end

    it 'returns error if score is not in range' do
      params[:movie][:score] = 11
      post :create, params: params

      expect(response).to have_http_status(422)
    end
  end

  describe 'DELETE destroy' do
    it 'destroy given movie' do
      delete :destroy, params: { id: @movie.id }
      expect(response).to be_successful
      # Ensure record has been deleted from DB
      expect(Movie.exists?(@movie.id)).to eq false
    end

    it 'returns error if id is invalid' do
      delete :destroy, params: { id: 0 }
      expect(response).to have_http_status(404)
    end
  end
end
