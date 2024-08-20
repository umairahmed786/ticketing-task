
FactoryBot.define do
  factory :issue_history do
    # association :field_change 
    # association :comment 
    association :issue
    association :user
    association :organization
  end
end
