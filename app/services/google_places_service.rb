require 'net/http'
require 'uri'
require 'json'
require 'cgi'

class GooglePlacesService
  def initialize(lat, lng, radius = 1500)
    @lat = lat
    @lng = lng
    @radius = radius
    @api_key = ENV['GOOGLE_MAPS_API_KEY']
  end

  def fetch_and_save_gyms
    keyword = CGI.escape("ジム")
    url = URI("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@lat},#{@lng}&radius=#{@radius}&keyword=#{keyword}&language=ja&key=#{@api_key}")
  
    response = Net::HTTP.get(url)
    result = JSON.parse(response)
  
    puts "📡 APIレスポンスステータス: #{result["status"]}"
    puts "📦 件数: #{result["results"].count}"
  
    result["results"].each do |place|
      name = place["name"]
      address = place["vicinity"]
      lat = place.dig("geometry", "location", "lat")
      lng = place.dig("geometry", "location", "lng")

      next unless lat.present? && lng.present?

      gym = Gym.find_or_initialize_by(name: name, address: address)
      gym.latitude = lat
      gym.longitude = lng
      if gym.save
        puts "✅ 保存成功: #{gym.name}"
      else
        puts "❌ 保存失敗: #{gym.errors.full_messages}"
      end
    end
  end
end
