# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 既存データを削除（依存関係を考慮した順序）
WeeklyMenu.destroy_all
User.destroy_all
Plan.destroy_all
Frequency.destroy_all
Gym.destroy_all

# 1. まずFrequencyを作成（他のテーブルから参照されるため）
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

# 2. Planを作成
plans = [
  { name: "健康維持", title: "健康維持", description: "ライトなトレーニングプラン" },
  { name: "ダイエット", title: "ダイエット", description: "バランスの取れたトレーニングプラン" },
  { name: "ゴリマッチョ", title: "ゴリマッチョ", description: "ハードトレーニングプラン" }
]
plans.each do |plan_data|
  Plan.create!(plan_data)
end
puts "✅ Plan データ作成完了"

# 3. Userを作成
first_plan = Plan.first
first_frequency = Frequency.first

user = User.create!(
  email: "test@example.com",
  password: "password",
  password_confirmation: "password",
  name: "テストユーザー",
  username: "testuser",
  plan_id: first_plan.id,
  frequency_id: first_frequency.id
)
puts "✅ User: #{user.inspect}"

# プランと頻度のオブジェクトを取得
soft_plan = Plan.find_by!(title: "健康維持")
diet_plan = Plan.find_by!(title: "ダイエット")
advanced_plan = Plan.find_by!(title: "ゴリマッチョ")

# 頻度を取得
freq_once = Frequency.find_by!(name: "週1回")
freq_two_three = Frequency.find_by!(name: "週2~3回")
freq_four_five = Frequency.find_by!(name: "週4~5回")
freq_six_seven = Frequency.find_by!(name: "週6~7回")

# 今週の月曜日から開始
start_date = Date.today.beginning_of_week

weekly_menus = [
  # ===== 健康維持プラン =====

  # 健康維持プラン - 週1回
  { name: "月曜日 - 全身軽トレ", description: "軽いストレッチ(15分)・自重スクワット 2セット×8回・腕立て伏せ 2セット×3回・プランク 20秒×2セット", plan_id: soft_plan&.id, frequency_id: freq_once.id, scheduled_date: start_date },

  # 健康維持プラン - 週2~3回
  { name: "月曜日 - 全身軽トレ", description: "軽いストレッチ(10分)・自重スクワット 3セット×10回・腕立て伏せ 3セット×5回・プランク 30秒×3セット", plan_id: soft_plan&.id, frequency_id: freq_two_three.id, scheduled_date: start_date },
  { name: "木曜日 - 有酸素", description: "ウォーキング 30分・体操 15分・ストレッチ 10分", plan_id: soft_plan&.id, frequency_id: freq_two_three.id, scheduled_date: start_date + 3.days },

  # 健康維持プラン - 週4~5回
  { name: "月曜日 - 上半身軽トレ", description: "腕立て伏せ 3セット×5回・ダンベル軽量 3セット×8回・ショルダー軽量 3セット×8回", plan_id: soft_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date },
  { name: "火曜日 - 有酸素軽め", description: "ウォーキング 20分・軽いジョギング 10分・ストレッチ 10分", plan_id: soft_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 1.day },
  { name: "木曜日 - 下半身軽トレ", description: "スクワット 3セット×8回・ランジ 3セット×6回・カーフレイズ 3セット×10回", plan_id: soft_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - 全身軽め", description: "軽い全身運動・ヨガ 15分・ストレッチ 15分", plan_id: soft_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 4.days },

  # 健康維持プラン - 週6~7回
  { name: "月曜日 - 上半身軽トレ", description: "腕立て伏せ 3セット×8回・ダンベル軽量 3セット×10回・プランク 30秒×3セット", plan_id: soft_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date },
  { name: "火曜日 - 有酸素", description: "ウォーキング 25分・軽いジョギング 15分・ストレッチ 10分", plan_id: soft_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 1.day },
  { name: "水曜日 - 下半身軽トレ", description: "スクワット 3セット×10回・ランジ 3セット×8回・カーフレイズ 3セット×12回", plan_id: soft_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 2.days },
  { name: "木曜日 - 柔軟性", description: "ヨガ 20分・ストレッチ 20分・軽い体操 10分", plan_id: soft_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - 全身軽め", description: "軽い全身運動・腕立て伏せ 2セット×5回・スクワット 2セット×8回", plan_id: soft_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 4.days },
  { name: "土曜日 - アクティブレスト", description: "軽いウォーキング 30分・ストレッチ 15分", plan_id: soft_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 5.days },

  # ===== ダイエットプラン =====

  # ダイエットプラン - 週1回
  { name: "月曜日 - 全身脂肪燃焼", description: "有酸素運動 20分・スクワット 3セット×12回・腕立て伏せ 3セット×8回・プランク 45秒×3セット", plan_id: diet_plan&.id, frequency_id: freq_once.id, scheduled_date: start_date },

  # ダイエットプラン - 週2~3回
  { name: "月曜日 - 上半身＋有酸素", description: "腕立て伏せ 3セット×8回・ダンベルカール 3セット×10回・ショルダープレス 3セット×8回・有酸素 15分", plan_id: diet_plan&.id, frequency_id: freq_two_three.id, scheduled_date: start_date },
  { name: "木曜日 - 下半身＋有酸素", description: "スクワット 3セット×12回・ランジ 3セット×10回・有酸素運動 20分・腹筋 3セット×15回", plan_id: diet_plan&.id, frequency_id: freq_two_three.id, scheduled_date: start_date + 3.days },

  # ダイエットプラン - 週4~5回
  { name: "月曜日 - 胸・肩", description: "ベンチプレス 4セット×8-10回・インクラインベンチプレス 3セット×10回・ショルダープレス 3セット×10回・サイドレイズ 3セット×12回", plan_id: diet_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date },
  { name: "火曜日 - 有酸素", description: "ランニング 30分・バイク 20分・腹筋 4セット×15回・プランク 1分×3セット", plan_id: diet_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 1.day },
  { name: "水曜日 - 背中・腕", description: "デッドリフト 4セット×8回・懸垂/ラットプルダウン 3セット×10回・バーベルカール 3セット×10回・トライセップス 3セット×10回", plan_id: diet_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 2.days },
  { name: "木曜日 - 脚", description: "スクワット 4セット×10-12回・レッグプレス 3セット×12回・カーフレイズ 4セット×15回・レッグカール 3セット×12回", plan_id: diet_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - HIIT", description: "HIIT 20分・体幹トレーニング 15分・ストレッチ 10分", plan_id: diet_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 4.days },

  # ダイエットプラン - 週6~7回
  { name: "月曜日 - 胸・肩", description: "ベンチプレス 4セット×10回・インクラインベンチプレス 4セット×10回・ショルダープレス 4セット×10回・サイドレイズ 4セット×12回", plan_id: diet_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date },
  { name: "火曜日 - 有酸素", description: "ランニング 35分・バイク 25分・腹筋 5セット×20回・プランク 1.5分×3セット", plan_id: diet_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 1.day },
  { name: "水曜日 - 背中・腕", description: "デッドリフト 4セット×10回・懸垂/ラットプルダウン 4セット×10回・バーベルカール 4セット×10回・トライセップス 4セット×10回", plan_id: diet_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 2.days },
  { name: "木曜日 - 脚", description: "スクワット 5セット×12回・レッグプレス 4セット×15回・カーフレイズ 5セット×20回・レッグカール 4セット×15回", plan_id: diet_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - HIIT", description: "HIIT 25分・体幹トレーニング 20分・ストレッチ 15分", plan_id: diet_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 4.days },
  { name: "土曜日 - 全身", description: "全身サーキットトレーニング 30分・有酸素 20分・ストレッチ 10分", plan_id: diet_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 5.days },

  # ===== ゴリマッチョプラン =====

  # ゴリマッチョプラン - 週1回
  { name: "月曜日 - 全身高強度", description: "ベンチプレス 4セット×6回・スクワット 4セット×6回・デッドリフト 3セット×5回・懸垂 3セット×限界", plan_id: advanced_plan&.id, frequency_id: freq_once.id, scheduled_date: start_date },

  # ゴリマッチョプラン - 週2~3回
  { name: "月曜日 - 上半身", description: "ベンチプレス 4セット×6-8回・インクラインベンチプレス 3セット×8回・ショルダープレス 4セット×6回・懸垂 3セット×限界", plan_id: advanced_plan&.id, frequency_id: freq_two_three.id, scheduled_date: start_date },
  { name: "木曜日 - 下半身", description: "スクワット 5セット×6回・デッドリフト 4セット×5回・レッグプレス 4セット×8回・カーフレイズ 5セット×15回", plan_id: advanced_plan&.id, frequency_id: freq_two_three.id, scheduled_date: start_date + 3.days },

  # ゴリマッチョプラン - 週4~5回
  { name: "月曜日 - 胸", description: "ベンチプレス 5セット×6-8回・インクラインベンチプレス 4セット×8回・ディップス 3セット×10回・ダンベルフライ 3セット×12回", plan_id: advanced_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date },
  { name: "火曜日 - 背中", description: "デッドリフト 5セット×5回・懸垂 4セット×限界・バーベルロウ 4セット×8回・ラットプルダウン 3セット×10回", plan_id: advanced_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 1.day },
  { name: "水曜日 - 脚", description: "スクワット 5セット×6-8回・レッグプレス 4セット×10回・ルーマニアンデッドリフト 4セット×8回・レッグカール 4セット×10回", plan_id: advanced_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 2.days },
  { name: "木曜日 - 肩・腕", description: "ショルダープレス 5セット×6-8回・サイドレイズ 4セット×10回・バーベルカール 4セット×8回・トライセップス 4セット×8回", plan_id: advanced_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - 胸・腕", description: "インクラインベンチプレス 4セット×8回・ディップス 4セット×10回・ダンベルカール 4セット×8回・クローズグリップベンチプレス 4セット×8回", plan_id: advanced_plan&.id, frequency_id: freq_four_five.id, scheduled_date: start_date + 4.days },

  # ゴリマッチョプラン - 週6~7回
  { name: "月曜日 - 胸", description: "ベンチプレス 5セット×5-8回・インクラインベンチプレス 4セット×8回・ディップス 4セット×10回・ダンベルフライ 4セット×12回・プッシュアップ 3セット×限界", plan_id: advanced_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date },
  { name: "火曜日 - 背中", description: "デッドリフト 5セット×5回・懸垂 4セット×限界・バーベルロウ 4セット×8回・ラットプルダウン 4セット×10回・シュラッグ 3セット×12回", plan_id: advanced_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 1.day },
  { name: "水曜日 - 脚", description: "スクワット 5セット×8回・レッグプレス 4セット×12回・ルーマニアンデッドリフト 4セット×10回・レッグカール 4セット×12回・カーフレイズ 5セット×15回", plan_id: advanced_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 2.days },
  { name: "木曜日 - 肩・腕", description: "ショルダープレス 5セット×8回・サイドレイズ 4セット×12回・リアデルト 4セット×12回・バーベルカール 4セット×10回・トライセップス 4セット×10回", plan_id: advanced_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 3.days },
  { name: "金曜日 - 胸・腕", description: "インクラインベンチプレス 4セット×8回・ディップス 4セット×12回・ダンベルカール 4セット×10回・クローズグリップベンチプレス 4セット×10回", plan_id: advanced_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 4.days },
  { name: "土曜日 - 背中・肩", description: "懸垂 4セット×限界・バーベルロウ 4セット×10回・アップライトロウ 4セット×12回・フェイスプル 3セット×15回", plan_id: advanced_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 5.days },
  { name: "日曜日 - 軽い有酸素", description: "軽いジョギング 30分・ストレッチ・マッサージ", plan_id: advanced_plan&.id, frequency_id: freq_six_seven.id, scheduled_date: start_date + 6.days }
]

weekly_menus.each do |menu|
  if menu[:plan_id].present? && menu[:frequency_id].present?
    puts "✅ WeeklyMenu 作成: #{menu[:name]} (#{Plan.find(menu[:plan_id]).title} - #{Frequency.find(menu[:frequency_id]).name})"
    WeeklyMenu.create!(menu)
  else
    puts "❌ スキップ: plan_id または frequency_id が nil のため作成不可: #{menu.inspect}"
  end
end
puts "✅ WeeklyMenu データ作成完了"
