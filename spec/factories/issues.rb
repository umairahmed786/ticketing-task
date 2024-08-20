FactoryBot.define do
  factory :issue do
    title { "New Issue" }
    description { "A detailed description of the issue." }
    state { 'new' }
    complexity_point { 3 }
    association :project
    association :assignee, factory: :user
    association :organization
  end
end