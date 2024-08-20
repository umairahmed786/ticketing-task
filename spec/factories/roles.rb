FactoryBot.define do
  factory :role do
    name { 'user' }

    trait :owner do
      name { 'owner' }
    end

    trait :admin do
      name { 'admin' }
    end

    trait :project_manager do
      name { 'project_manager' }
    end

    trait :general_user do
      name { 'general_user' }
    end
  end
end
