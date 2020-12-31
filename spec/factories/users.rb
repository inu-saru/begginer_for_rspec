FactoryBot.define do
  factory :user do
    first_name { FFaker::NameJA.first_name }
    last_name { FFaker::NameJA.last_name }
    email { FFaker::Internet.email }
  end
end
