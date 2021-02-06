require 'rails_helper'

feature 'Delete movie' do
  before do
    @movie = FactoryBot.create(:movie)
  end

  scenario 'deletes a movie', js: true do
    visit("/movie/#{@movie.id}")

    find(:css, 'button[name=delete]').click
    page.accept_alert
    wait_for_ajax

    # Find success message
    expect(page).to have_css('div.message-box.success')

    # Ensure movie is actually deleted
    expect(Movie.exists?(@movie.id)).to eq false
  end
end
