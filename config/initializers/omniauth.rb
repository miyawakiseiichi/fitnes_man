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
      redirect_uri: ENV['GOOGLE_REDIRECT_URI'],
      origin_param: 'return_to',
      ssl: { verify: !Rails.env.development? },
      authorized_domains: ['fitnes-man-production.onrender.com'],
      hd: 'fitnes-man-production.onrender.com',
      setup: (lambda do |env|
        if Rails.env.production?
          env['omniauth.strategy'].options[:client_options].site = 'https://accounts.google.com'
          env['omniauth.strategy'].options[:client_options].authorize_url = 'https://accounts.google.com/o/oauth2/auth'
          env['omniauth.strategy'].options[:client_options].token_url = 'https://accounts.google.com/o/oauth2/token'
        end
      end)
    }
end

# CSRFトークン検証をスキップする設定
OmniAuth.config.allowed_request_methods = [:get, :post]
OmniAuth.config.silence_get_warning = true

# プロダクション環境での追加設定
if Rails.env.production?
  OmniAuth.config.full_host = ENV['GOOGLE_REDIRECT_URI'].split('/callback').first
end 