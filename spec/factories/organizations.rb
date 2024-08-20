FactoryBot.define do
  factory :organization do
    sequence(:name) { |n| "Organization#{n}" }
    sequence(:subdomain) { |n| "org#{n}" }
  end
end
