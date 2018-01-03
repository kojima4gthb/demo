FactoryBot.define do
  factory :comment do
    body Faker::Cat.name
    status 'unapproved'
    entry_id 1
  end
end