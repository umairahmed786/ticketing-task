
FactoryBot.define do
  factory :comment do
    association :organization
    association :issue_history
    content { "This is a sample comment." }
  end
end
