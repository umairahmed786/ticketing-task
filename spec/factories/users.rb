FactoryBot.define do
  factory :user do
    name { "Umair Ahmed" }
    sequence(:email) { |n| "umair.ahmed#{n}@7vals.com" }
    password { "password" }
    password_confirmation { "password" }
    role { create(:role) }  
    association :organization
  end
end
