FactoryBot.define do
  factory :movie do
    sequence(:title) { |n| "movie-#{n}" }
    sequence(:image) { |n| "https://image-#{n}" }
    sequence(:score) { rand(0..10) }
    sequence(:rating) { rand(1..5) }
    sequence(:year) { rand(1900..2100) }
    color { '#ff0000' }
  end
end
