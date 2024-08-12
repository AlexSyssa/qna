FactoryBot.define do
  factory :award do
    name { 'Award Test' }
    image { 'https://commons.wikimedia.org/wiki/Category:Quality_images#/media/File:Quality_images_logo.svg/2' }
    user { nil }
    question { nil }
  end
end
