class GymsController < ApplicationController
  before_action :authenticate_user! # ユーザー認証が必要
  def index
    if params[:latitude].present? && params[:longitude].present?
      @gyms = Gym.near([ params[:latitude], params[:longitude] ], 10, units: :km)
    else
      @gyms = Gym.all
    end
  end

  def import_from_google
    lat = params[:lat]
    lng = params[:lng]

    if lat.present? && lng.present?
      service = GooglePlacesService.new(lat, lng)
      service.fetch_and_save_gyms
      redirect_to gyms_path(latitude: lat, longitude: lng), notice: "Googleからジムを取得しました！"
    else
      redirect_to gyms_path, alert: "位置情報が取得できませんでした。"
    end
  end
end
