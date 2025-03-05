class ProteinsController < ApplicationController
  before_action :authenticate_user! # ユーザー認証が必要
  def index
  end
end
