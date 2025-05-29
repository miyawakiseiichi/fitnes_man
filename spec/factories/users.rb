FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:username) { |n| "testuser#{n}" }
    
    association :plan
    association :frequency

    trait :with_health_plan do
      association :plan, :health_maintenance
    end

    trait :with_diet_plan do
      association :plan, :diet
    end

    trait :with_muscle_plan do
      association :plan, :muscle_building
    end

    trait :admin do
      # Add admin attributes if needed
    end
  end
end 