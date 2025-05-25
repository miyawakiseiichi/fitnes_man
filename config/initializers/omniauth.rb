Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV['GOOGLE_CLIENT_ID'],
    ENV['GOOGLE_CLIENT_SECRET'],
    {
      scope: 'email,profile',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50,
      access_type: 'online',
      name: 'google',
      redirect_uri: "#{ENV['GOOGLE_REDIRECT_URI']}/callback",
      origin_param: 'return_to',
      ssl: { verify: !Rails.env.development? }  # 開発環境ではSSL検証をスキップ
    }
end

# CSRFトークン検証をスキップする設定
OmniAuth.config.allowed_request_methods = [:get, :post]
OmniAuth.config.silence_get_warning = true

# プロダクション環境での追加設定
if Rails.env.production?
  OmniAuth.config.full_host = ENV['GOOGLE_REDIRECT_URI'].split('/auth/google_oauth2').first
end 