#!/usr/bin/env bash
# エラー発生時にスクリプトを停止
set -o errexit

# Ruby & JSの依存関係をインストール
bundle install
yarn install

# フロントエンドのビルド（必要に応じて）
yarn build

# アセットのプリコンパイル
bundle exec rake assets:precompile

# マイグレーション前にFrequencyデータを確実に作成
bundle exec rake db:ensure_frequencies

# ★ 本番用マイグレーションをここで実行（重要！）
bundle exec rails db:migrate

# データの初期投入（任意）
bundle exec rails db:seed
