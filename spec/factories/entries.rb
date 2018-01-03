FactoryBot.define do
  factory :entry do
    title Faker::Cat.name
    body Faker::Cat.name
    blog_id 1
  end
end