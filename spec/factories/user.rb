FactoryBot.define do
    factory :user do
      email    { Faker::Internet.email }
      password { Faker::Internet.password }
      my_integer { 0 }
    end
  end