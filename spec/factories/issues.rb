FactoryBot.define do
  factory :issue do
    sequence(:title) { |n| "Issue Title #{n}" }
    description { "A detailed description of the issue." }
    state { 'new' }
    complexity_point { 3 }
    association :project
    association :assignee, factory: :user
    association :organization
  end
end