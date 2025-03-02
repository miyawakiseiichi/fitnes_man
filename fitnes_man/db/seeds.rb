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


soft_plan = Plan.find_by(name: "健康維持")
diet_plan = Plan.find_by(name: "ダイエット")
advanced_plan = Plan.find_by(name: "ゴリマッチョ")

weekly_menus = [
  # 健康維持
  { plan_type: "健康維持", name: "月曜日", description: "軽いストレッチ・ウォーキング", plan_id: soft_plan.id},
  { plan_type: "健康維持", name: "火曜日", description: "自重スクワット・プランク", plan_id: soft_plan.id},
  { plan_type: "健康維持", name: "水曜日", description: "休息日", plan_id: soft_plan.id},
  { plan_type: "健康維持", name: "木曜日", description: "休息日", plan_id: soft_plan.id},
  { plan_type: "健康維持", name: "金曜日", description: "休息日", plan_id: soft_plan.id},
  { plan_type: "健康維持", name: "土曜日", description: "休息日", plan_id: soft_plan.id},
  { plan_type: "健康維持", name: "日曜日", description: "休息日", plan_id: soft_plan.id},

  # ダイエット
  { plan_type: "ダイエット", name: "月曜日", description: "スクワット・ベンチプレス・デッドリフト", plan_id: diet_plan.id},
  { plan_type: "ダイエット", name: "火曜日", description: "ランニング・プランク・腹筋", plan_id: diet_plan.id},
  { plan_type: "ダイエット", name: "水曜日", description: "休息日", plan_id: diet_plan.id},
  { plan_type: "ダイエット", name: "木曜日", description: "休息日", plan_id: diet_plan.id},
  { plan_type: "ダイエット", name: "金曜日", description: "休息日", plan_id: diet_plan.id},
  { plan_type: "ダイエット", name: "土曜日", description: "休息日", plan_id: diet_plan.id},
  { plan_type: "ダイエット", name: "日曜日", description: "休息日", plan_id: diet_plan.id},


  # ゴリマッチョ
  { plan_type: "ゴリマッチョ", name: "月曜日", description: "ベンチプレス・インクラインベンチプレス・ディップス・ダンベルフライ", plan_id: advanced_plan.id},
  { plan_type: "ゴリマッチョ", name: "火曜日", description: "懸垂", plan_id: advanced_plan.id},
  { plan_type: "ゴリマッチョ", name: "水曜日", description: "レッグプレス", plan_id: advanced_plan.id},
  { plan_type: "ゴリマッチョ", name: "木曜日", description: "ショルダープレス", plan_id: advanced_plan.id},
  { plan_type: "ゴリマッチョ", name: "金曜日", description: "休息日", plan_id: advanced_plan.id},
  { plan_type: "ゴリマッチョ", name: "土曜日", description: "休息日", plan_id: advanced_plan.id},
  { plan_type: "ゴリマッチョ", name: "日曜日", description: "休息日", plan_id: advanced_plan.id},

]

