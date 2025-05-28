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

# 今週の月曜日から開始
start_date = Date.today.beginning_of_week

weekly_menus = [
  # 健康維持プラン - 週2回の軽いトレーニング
  { name: "月曜日 - 全身軽トレ", description: "軽いストレッチ(10分)・自重スクワット 3セット×10回・腕立て伏せ 3セット×5回・プランク 30秒×3セット", plan_id: soft_plan&.id, scheduled_date: start_date },
  { name: "火曜日 - 休息", description: "軽いウォーキング 20分・ストレッチ 10分", plan_id: soft_plan&.id, scheduled_date: start_date + 1.day },
  { name: "水曜日 - 休息", description: "休息日 - 軽いストレッチのみ", plan_id: soft_plan&.id, scheduled_date: start_date + 2.days },
  { name: "木曜日 - 有酸素", description: "ウォーキング 30分・体操 15分・ストレッチ 10分", plan_id: soft_plan&.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - 休息", description: "休息日 - リラックス", plan_id: soft_plan&.id, scheduled_date: start_date + 4.days },
  { name: "土曜日 - 休息", description: "休息日 - 軽いストレッチのみ", plan_id: soft_plan&.id, scheduled_date: start_date + 5.days },
  { name: "日曜日 - 休息", description: "完全休息日", plan_id: soft_plan&.id, scheduled_date: start_date + 6.days },

  # ダイエットプラン - 週4回のバランス型トレーニング
  { name: "月曜日 - 胸・肩", description: "ベンチプレス 4セット×8-10回・インクラインベンチプレス 3セット×10回・ショルダープレス 3セット×10回・サイドレイズ 3セット×12回", plan_id: diet_plan&.id, scheduled_date: start_date },
  { name: "火曜日 - 有酸素", description: "ランニング 30分・バイク 20分・腹筋 4セット×15回・プランク 1分×3セット", plan_id: diet_plan&.id, scheduled_date: start_date + 1.day },
  { name: "水曜日 - 背中・腕", description: "デッドリフト 4セット×8回・懸垂/ラットプルダウン 3セット×10回・バーベルカール 3セット×10回・トライセップス 3セット×10回", plan_id: diet_plan&.id, scheduled_date: start_date + 2.days },
  { name: "木曜日 - 脚", description: "スクワット 4セット×10-12回・レッグプレス 3セット×12回・カーフレイズ 4セット×15回・レッグカール 3セット×12回", plan_id: diet_plan&.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - 有酸素", description: "HIIT 20分・体幹トレーニング 15分・ストレッチ 10分", plan_id: diet_plan&.id, scheduled_date: start_date + 4.days },
  { name: "土曜日 - 休息", description: "アクティブレスト - 軽いヨガ・ストレッチ", plan_id: diet_plan&.id, scheduled_date: start_date + 5.days },
  { name: "日曜日 - 休息", description: "完全休息日", plan_id: diet_plan&.id, scheduled_date: start_date + 6.days },

  # ゴリマッチョプラン - 週6回の高強度トレーニング
  { name: "月曜日 - 胸", description: "ベンチプレス 5セット×5-8回・インクラインベンチプレス 4セット×8回・ディップス 4セット×10回・ダンベルフライ 4セット×12回・プッシュアップ 3セット×限界", plan_id: advanced_plan&.id, scheduled_date: start_date },
  { name: "火曜日 - 背中", description: "デッドリフト 5セット×5回・懸垂 4セット×限界・バーベルロウ 4セット×8回・ラットプルダウン 4セット×10回・シュラッグ 3セット×12回", plan_id: advanced_plan&.id, scheduled_date: start_date + 1.day },
  { name: "水曜日 - 脚", description: "スクワット 5セット×8回・レッグプレス 4セット×12回・ルーマニアンデッドリフト 4セット×10回・レッグカール 4セット×12回・カーフレイズ 5セット×15回", plan_id: advanced_plan&.id, scheduled_date: start_date + 2.days },
  { name: "木曜日 - 肩・腕", description: "ショルダープレス 5セット×8回・サイドレイズ 4セット×12回・リアデルト 4セット×12回・バーベルカール 4セット×10回・トライセップス 4セット×10回", plan_id: advanced_plan&.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - 胸・腕", description: "インクラインベンチプレス 4セット×8回・ディップス 4セット×12回・ダンベルカール 4セット×10回・クローズグリップベンチプレス 4セット×10回", plan_id: advanced_plan&.id, scheduled_date: start_date + 4.days },
  { name: "土曜日 - 背中・肩", description: "懸垂 4セット×限界・バーベルロウ 4セット×10回・アップライトロウ 4セット×12回・フェイスプル 3セット×15回", plan_id: advanced_plan&.id, scheduled_date: start_date + 5.days },
  { name: "日曜日 - 休息", description: "完全休息日 - ストレッチ・マッサージ", plan_id: advanced_plan&.id, scheduled_date: start_date + 6.days }
]

weekly_menus.each do |menu|
  if menu[:plan_id].present?
    puts "✅ WeeklyMenu 作成: #{menu[:name]}"  # ✅ デバッグ用出力
    WeeklyMenu.create!(menu)
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
