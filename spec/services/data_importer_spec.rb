require 'rails_helper'

RSpec.describe DataImporter do
  let(:json) do
    [{
      title: 'The Matrix',
      alternative_titles: ['Matrix', 'La Matrice'],
      year: 1999,
      genre: ['Action', 'Science Fiction'],
      image: 'https://poster.jpg',
      actors: ['Keanu Reeves', 'Laurence Fishburne'],
      actor_facets: ['https://image1|Keanu Reeves', 'https://image2|Laurence Fishburne'],
      color: '#000000',
      rating: 5,
      score: 9.7,
    }, {
      title: 'The Matrix Reloaded',
      alternative_titles: ['Matrix Reloaded', 'La Matrice rechargée'],
      year: 2003,
      genre: ['Action', 'Science Fiction'],
      image: 'https://poster.jpg',
      actors: ['Keanu Reeves', 'Laurence Fishburne', 'Monica Bellucci'],
      actor_facets: ['https://image1|Keanu Reeves', 'https://image2|Laurence Fishburne',
                     'https://image3|Monica Bellucci'],
      color: '#000000',
      rating: 4,
      score: 7.5,
    }]
  end

  it 'creates models from json file' do
    # Generate tmp file from json sample
    File.write('tmp/records.json', json.to_json)

    DataImporter.new.run!('tmp/records.json')

    expect(Movie.count).to eq 2
    expect(Actor.count).to eq 3 # Ensure actors are deduplicated

    movie = Movie.first
    expect(movie.title).to eq 'The Matrix'
    expect(movie.alternative_titles).to eq ['Matrix', 'La Matrice']
    expect(movie.actors.count).to eq 2
    expect(movie.actors.pluck(:name)).to match_array(['Keanu Reeves', 'Laurence Fishburne'])

    actor = Actor.first
    expect(actor.name).to eq 'Keanu Reeves'
    expect(actor.image).to eq 'https://image1'
    expect(actor.movies.count).to eq 2
  end
end
