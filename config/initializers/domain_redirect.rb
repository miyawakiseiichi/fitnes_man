class DomainRedirect
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if Rails.env.production? && request.host.start_with?('www.')
      # wwwありのURLをwwwなしにリダイレクト
      [301, { 'Location' => request.url.sub('www.', '') }, ['Moved Permanently']]
    else
      @app.call(env)
    end
  end
end

Rails.application.config.middleware.insert_before(Rack::Runtime, DomainRedirect) if Rails.env.production? 