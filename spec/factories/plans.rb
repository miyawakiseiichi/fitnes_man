FactoryBot.define do
  factory :plan do
    sequence(:name) { |n| "Plan #{n}" }
    sequence(:title) { |n| "Title #{n}" }
    description { "Test plan description" }

    trait :health_maintenance do
      name { "健康維持" }
      title { "健康維持" }
      description { "ライトなトレーニングプラン" }
    end

    trait :diet do
      name { "ダイエット" }
      title { "ダイエット" }
      description { "バランスの取れたトレーニングプラン" }
    end

    trait :muscle_building do
      name { "ゴリマッチョ" }
      title { "ゴリマッチョ" }
      description { "ハードトレーニングプラン" }
    end
  end
end
