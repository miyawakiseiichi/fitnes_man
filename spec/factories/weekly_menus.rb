FactoryBot.define do
  factory :weekly_menu do
    name { "月曜日 - 胸トレ" }
    description { "ベンチプレス 4セット×8回・インクラインベンチプレス 3セット×10回" }
    scheduled_date { Date.current }
    association :plan
    association :frequency

    trait :monday_chest do
      name { "月曜日 - 胸" }
      description { "ベンチプレス 5セット×5-8回・インクラインベンチプレス 4セット×8回" }
      scheduled_date { Date.current.beginning_of_week }
    end

    trait :tuesday_back do
      name { "火曜日 - 背中" }
      description { "デッドリフト 5セット×5回・懸垂 4セット×限界" }
      scheduled_date { Date.current.beginning_of_week + 1.day }
    end

    trait :rest_day do
      name { "日曜日 - 休息" }
      description { "完全休息日 - ストレッチ・マッサージ" }
      scheduled_date { Date.current.beginning_of_week + 6.days }
    end
  end
end 