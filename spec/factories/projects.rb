FactoryBot.define do
  factory :project do
    title { "My Project" }
    description { "A detailed description of the project." }
    association :admin, factory: :user
    association :project_manager, factory: :user
    association :organization
  end
end
