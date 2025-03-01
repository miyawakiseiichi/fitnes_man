#!/usr/bin/env bash
# エラー時に即終了
set -o errexit

bundle install
yarn install
yarn build # esbuildでJSをバンドル
bundle exec rake assets:precompile # sprocketsでCSSをプリコンパイル
bundle exec ridgepole -c config/database.yml -E production --apply -f db/schemas/Schemafile # DBマイグレーション（ridgepole使用）