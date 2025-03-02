#!/usr/bin/env bash
# エラー発生時にスクリプトを停止
set -o errexit

# Ruby & JSの依存関係をインストール
docker compose exec web bundle install
docker compose exec web yarn install

# フロントエンドのビルド
docker compose exec web yarn build  # JavaScriptをesbuildでバンドル（必要に応じて変更）

# アセットのプリコンパイル
docker compose exec web bundle exec rake assets:precompile  # CSSをSprocketsでコンパイル

# ridgepole を使わない場合
docker compose exec web bundle exec rails db:migrate
