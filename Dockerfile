FROM ruby:3.2.2

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

# 必要なパッケージをインストール
RUN apt-get update -qq \
  && apt-get install -y ca-certificates curl gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg -o /etc/apt/trusted.gpg.d/yarnpkg.gpg \
  && NODE_MAJOR=18 \
  && wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -y build-essential libpq-dev nodejs yarn

# 作業ディレクトリを作成
RUN mkdir /fitnes_man
WORKDIR /fitnes_man

# Bundler のバージョンを指定してインストール
RUN gem install bundler:2.3.17

# Gemfile, Gemfile.lock をコピーして `bundle install`
COPY Gemfile /fitnes_man/Gemfile
COPY Gemfile.lock /fitnes_man/Gemfile.lock
RUN bundle install

# Yarn 関連のインストール
COPY yarn.lock /fitnes_man/yarn.lock
RUN yarn install

# アプリ全体をコピー
COPY . /fitnes_man/

# ✅ `bin/` を `/fitness_planner/bin/` にコピー
COPY bin /fitnes_man/bin

# ✅ `bin/dev` に実行権限を付与
RUN chmod +x /fitnes_man/bin/dev

# サーバー起動コマンド
CMD ["sh", "-c", "bin/rails server -b 0.0.0.0 -p $PORT"]