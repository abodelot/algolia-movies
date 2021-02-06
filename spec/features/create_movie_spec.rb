require 'rails_helper'

feature 'Create movie' do
  scenario 'creates a new movie', js: true do
    visit('/new-movie')

    # Fill form
    find('input[name=title]').fill_in(with: 'Star Wars')
    find('input[name=year]').fill_in(with: '1979')
    find('input[name=score]').fill_in(with: '8.4')
    find('input[name=rating').fill_in(with: '5')
    find('input[name=image').fill_in(with: 'http://host/picture.jpg')

    # Submit form
    find('button[type=submit]').click
    wait_for_ajax

    # Find success message
    expect(page).to have_css('div.message-box.success')

    movie = Movie.last
    expect(movie.title).to eq 'Star Wars'
  end

  scenario 'some attributes are missing', js: true do
    visit('/new-movie')

    # Fill form
    find('input[name=title]').fill_in(with: 'Star Wars')
    find('input[name=year]').fill_in(with: '1979')

    # Submit form
    find('button[type=submit]').click
    wait_for_ajax

    expect(Movie.exists?(title: 'Star Wars')).to eq false
  end

  scenario 'some attributes have illegal values', js: true do
    visit('/new-movie')

    # Fill form
    find('input[name=title]').fill_in(with: 'Star Wars')
    find('input[name=year]').fill_in(with: '2020')
    find('input[name=score]').fill_in(with: '8.4')
    find('input[name=rating').fill_in(with: '5')
    # pass HTML validation, but not ActiveRecord validation
    find('input[name=image').fill_in(with: 'INVALID_URL!')

    # Submit form
    find('button[type=submit]').click

    # Find error message
    expect(page).to have_css('div.message-box.error')

    expect(Movie.exists?(title: 'Star Wars')).to eq false
  end
end
