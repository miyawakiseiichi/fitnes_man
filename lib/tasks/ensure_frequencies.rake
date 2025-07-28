namespace :db do
  desc "Ensure frequencies exist before migration"
  task ensure_frequencies: :environment do
    # Frequencyテーブルが存在し、データがない場合のみ作成
    if defined?(Frequency) && Frequency.count == 0
      frequencies = [ "週1回", "週2~3回", "週4~5回", "週6~7回" ]
      frequencies.each do |name|
        Frequency.create!(name: name)
      end
      puts "✅ Frequencies created"
    else
      puts "✅ Frequencies already exist"
    end
  end
end
