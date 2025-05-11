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

# ridgepole を使わない場合
bundle exec rails db:seed