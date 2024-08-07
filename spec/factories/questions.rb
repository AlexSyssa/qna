# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Question title #{n}"
  end

  factory :question do
    title
    body { 'MyText' }
    user

    trait :invalid do
      title { nil }
    end
  end
end
