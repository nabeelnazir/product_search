FactoryBot.define do
    factory :product do
      title    { 'title' }
      description { 'description' }
      country { 'country' }
      tags { 'tags' }
      price { 'price' }
    end
  end