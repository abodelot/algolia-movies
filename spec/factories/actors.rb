FactoryBot.define do
  factory :actor do
    sequence(:name) { |n| "name-#{n}" }
    sequence(:image) { |n| "https://image-#{n}" }
  end
end
