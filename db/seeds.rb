# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Plan.destroy_all
WeeklyMenu.destroy_all
Frequency.destroy_all
User.destroy_all
Gym.destroy_all

frequencies = [
  "週1回",
  "週2~3回",
  "週4~5回",
  "週6~7回"
]
frequencies.each do |name|
  Frequency.create!(name: name)
end
puts "✅ Frequency データ作成完了"

plan = Plan.first || Plan.create!(name: "健康維持", title: "健康維持", description: "ライトなトレーニングプラン")

user = User.find_or_initialize_by(email: "test@example.com")
user.update!(
  password: "password",  # Devise の `password` は `update!` で設定する
  password_confirmation: "password",
  name: "テストユーザー",
  username: "testuser",
  plan_id: plan.id,
  frequency: Frequency.first
)
puts "✅ User: #{user.inspect}"  # ユーザーが正しく作成されているか確認

plans = [
  { name: "健康維持", title: "健康維持", description: "ライトなトレーニングプラン", user_id: user.id },
  { name: "ダイエット", title: "ダイエット", description: "バランスの取れたトレーニングプラン", user_id: user.id },
  { name: "ゴリマッチョ", title: "ゴリマッチョ", description: "ハードトレーニングプラン", user_id: user.id }
]
plans.each do |plan_data|
  Plan.find_or_create_by!(name: plan_data[:name]) do |plan|
    plan.title = plan_data[:title]
    plan.description = plan_data[:description]
  end
end
puts "✅ Plan データ作成完了"

soft_plan = Plan.find_by!(title: "健康維持")
diet_plan = Plan.find_by!(title: "ダイエット")
advanced_plan = Plan.find_by!(title: "ゴリマッチョ")

weekly_menus = [
  # 健康維持
  { name: "月曜日", description: "軽いストレッチ・ウォーキング", plan_id: soft_plan&.id },
  { name: "火曜日", description: "自重スクワット・プランク", plan_id: soft_plan&.id },
  { name: "水曜日", description: "休息日", plan_id: soft_plan&.id },
  { name: "木曜日", description: "休息日", plan_id: soft_plan&.id },
  { name: "金曜日", description: "休息日", plan_id: soft_plan&.id },
  { name: "土曜日", description: "休息日", plan_id: soft_plan&.id },
  { name: "日曜日", description: "休息日", plan_id: soft_plan&.id },

  # ダイエット
  { name: "月曜日", description: "スクワット・ベンチプレス・デッドリフト", plan_id: diet_plan&.id },
  { name: "火曜日", description: "ランニング・プランク・腹筋", plan_id: diet_plan&.id },
  { name: "水曜日", description: "休息日", plan_id: diet_plan&.id },
  { name: "木曜日", description: "休息日", plan_id: diet_plan&.id },
  { name: "金曜日", description: "休息日", plan_id: diet_plan&.id },
  { name: "土曜日", description: "休息日", plan_id: diet_plan&.id },
  { name: "日曜日", description: "休息日", plan_id: diet_plan&.id },


  # ゴリマッチョ
  { name: "月曜日", description: "ベンチプレス・インクラインベンチプレス・ディップス・ダンベルフライ", plan_id: advanced_plan&.id },
  { name: "火曜日", description: "懸垂", plan_id: advanced_plan&.id },
  { name: "水曜日", description: "レッグプレス", plan_id: advanced_plan&.id },
  { name: "木曜日", description: "ショルダープレス", plan_id: advanced_plan&.id },
  { name: "金曜日", description: "休息日", plan_id: advanced_plan&.id },
  { name: "土曜日", description: "休息日", plan_id: advanced_plan&.id },
  { name: "日曜日", description: "休息日", plan_id: advanced_plan&.id }

]
weekly_menus.each do |menu|
  if menu[:plan_id].present?
    puts "✅ WeeklyMenu 作成: #{menu.inspect}"  # ✅ デバッグ用出力
    WeeklyMenu.create!(menu.except(:plan_type))  # plan_type を除外
  else
    puts "❌ スキップ: plan_id が nil のため作成不可: #{menu.inspect}"
  end
end
puts "✅ WeeklyMenu データ作成完了"

plans.each do |plan_data|
  Plan.find_or_create_by!(name: plan_data[:name]) do |plan|
    plan.description = plan_data[:description]
    plan.save!
  end
end
