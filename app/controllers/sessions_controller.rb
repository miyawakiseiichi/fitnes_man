class SessionsController < Devise::SessionsController
  def new
    @prefill_email = session[:prefill_email]
    super
  end

  def create
    super
  end

  def destroy
    super
  end
end
