# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

plans = [
  { name: "健康維持", description: "ライトなトレーニングプラン" },
  { name: "ダイエット", description: "バランスの取れたトレーニングプラン" },
  { name: "ゴリマッチョ", description: "ハードトレーニングプラン" }
]

frequencies = [
  { name: "週1回" },
  { name: "週2~3回" },
  { name: "週4~5回" },
  { name: "週6~7回" }
]
frequencies.each do |freq|
  Frequency.find_or_create_by!(name: freq[:name])
end

plans.each do |plan_data|
  Plan.find_or_create_by!(name: plan_data[:name]) do |plan|
    plan.description = plan_data[:description]
  end
end

soft_plan = Plan.find_by(name: "健康維持")
diet_plan = Plan.find_by(name: "ダイエット")
advanced_plan = Plan.find_by(name: "ゴリマッチョ")

weekly_menus = [
  # 健康維持
  { plan_type: "健康維持", name: "月曜日", description: "軽いストレッチ・ウォーキング", plan_id: soft_plan.id, day_of_week: 0},
  { plan_type: "健康維持", name: "火曜日", description: "自重スクワット・プランク", plan_id: soft_plan.id, day_of_week: 1},
  { plan_type: "健康維持", name: "水曜日", description: "休息日", plan_id: soft_plan.id, day_of_week: 2},
  { plan_type: "健康維持", name: "木曜日", description: "休息日", plan_id: soft_plan.id, day_of_week: 3},
  { plan_type: "健康維持", name: "金曜日", description: "休息日", plan_id: soft_plan.id, day_of_week: 4},
  { plan_type: "健康維持", name: "土曜日", description: "休息日", plan_id: soft_plan.id, day_of_week: 5},
  { plan_type: "健康維持", name: "日曜日", description: "休息日", plan_id: soft_plan.id, day_of_week: 6},

  # ダイエット
  { plan_type: "ダイエット", name: "月曜日", description: "スクワット・ベンチプレス・デッドリフト", plan_id: diet_plan.id, day_of_week: 0},
  { plan_type: "ダイエット", name: "火曜日", description: "ランニング・プランク・腹筋", plan_id: diet_plan.id, day_of_week: 1},
  { plan_type: "ダイエット", name: "水曜日", description: "休息日", plan_id: diet_plan.id, day_of_week: 2},
  { plan_type: "ダイエット", name: "木曜日", description: "休息日", plan_id: diet_plan.id, day_of_week: 3},
  { plan_type: "ダイエット", name: "金曜日", description: "休息日", plan_id: diet_plan.id, day_of_week: 4},
  { plan_type: "ダイエット", name: "土曜日", description: "休息日", plan_id: diet_plan.id, day_of_week: 5},
  { plan_type: "ダイエット", name: "日曜日", description: "休息日", plan_id: diet_plan.id, day_of_week: 6},


  # ゴリマッチョ
  { plan_type: "ゴリマッチョ", name: "月曜日", description: "ベンチプレス・インクラインベンチプレス・ディップス・ダンベルフライ", plan_id: advanced_plan.id, day_of_week: 0},
  { plan_type: "ゴリマッチョ", name: "火曜日", description: "懸垂", plan_id: advanced_plan.id, day_of_week: 1},
  { plan_type: "ゴリマッチョ", name: "水曜日", description: "レッグプレス", plan_id: advanced_plan.id, day_of_week: 2},
  { plan_type: "ゴリマッチョ", name: "木曜日", description: "ショルダープレス", plan_id: advanced_plan.id, day_of_week: 3},
  { plan_type: "ゴリマッチョ", name: "金曜日", description: "休息日", plan_id: advanced_plan.id, day_of_week: 4},
  { plan_type: "ゴリマッチョ", name: "土曜日", description: "休息日", plan_id: advanced_plan.id, day_of_week: 5},
  { plan_type: "ゴリマッチョ", name: "日曜日", description: "休息日", plan_id: advanced_plan.id, day_of_week: 6},

]

weekly_menus.each do |menu_data|
  WeeklyMenu.find_or_create_by!(plan_id: menu_data[:plan_id], day_of_week: menu_data[:day_of_week]) do |menu|
    menu.name = menu_data[:name]
    menu.description = menu_data[:description]
  end
end
