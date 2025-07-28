FactoryBot.define do
  factory :frequency do
    sequence(:name) { |n| "週#{n}回" }

    trait :weekly do
      sequence(:name) { |n| "週1回 #{n}" }
    end

    trait :twice_weekly do
      sequence(:name) { |n| "週2回 #{n}" }
    end

    trait :three_times_weekly do
      sequence(:name) { |n| "週3回 #{n}" }
    end

    trait :daily do
      sequence(:name) { |n| "毎日 #{n}" }
    end

    trait :four_to_five_times do
      name { "週4~5回" }
    end

    trait :six_to_seven_times do
      name { "週6~7回" }
    end
  end
end
