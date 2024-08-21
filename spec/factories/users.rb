FactoryBot.define do
  factory :user do
    name { 'Test User' }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    confirmed_at { Time.now }
    role { create(:role) }
    association :organization
  end
end
