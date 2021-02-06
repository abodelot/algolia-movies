require 'rails_helper'

RSpec.describe Movie do
  let(:movie) { FactoryBot.build(:movie) }

  describe 'validations' do
    it 'validates image is a URL' do
      movie.image = 'https://host/pic.png'
      expect(movie).to be_valid

      movie.image = 'http://host/path/to/image.jpg'
      expect(movie).to be_valid

      movie.image = ''
      expect(movie).to be_invalid

      movie.image = 'xxx\yyyy'
      expect(movie).to be_invalid
    end

    it 'validates year' do
      movie.year = 2000
      expect(movie).to be_valid

      movie.year = 1883
      expect(movie).to be_invalid

      movie.year = 2344
      expect(movie).to be_invalid
    end

    it 'validates rating' do
      movie.rating = 3
      expect(movie).to be_valid

      movie.rating = 0
      expect(movie).to be_invalid

      movie.rating = 8
      expect(movie).to be_invalid
    end
  end
end
