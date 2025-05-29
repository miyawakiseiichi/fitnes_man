FactoryBot.define do
  factory :frequency do
    name { "週2~3回" }

    trait :once_a_week do
      name { "週1回" }
    end

    trait :two_to_three_times do
      name { "週2~3回" }
    end

    trait :four_to_five_times do
      name { "週4~5回" }
    end

    trait :six_to_seven_times do
      name { "週6~7回" }
    end
  end
end 