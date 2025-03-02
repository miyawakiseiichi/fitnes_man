#!/usr/bin/env bash
# エラー発生時にスクリプトを停止
set -o errexit

# Ruby & JSの依存関係をインストール
bundle install
yarn install

# フロントエンドのビルド
yarn build  # JavaScriptをesbuildでバンドル（必要に応じて変更）

# アセットのプリコンパイル
bundle exec rake assets:precompile  # CSSをSprocketsでコンパイル

# DBマイグレーション（ridgepoleを使う場合）
bundle exec ridgepole -c config/database.yml -E production --apply -f db/schemas/Schemafile
# ※ ridgepole を使わない場合は ↓ のコマンドに変更
bundle exec rails db:migrate
