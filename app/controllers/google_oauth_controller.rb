require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

class GoogleOauthController < ApplicationController
  def authorize
    client_id = Google::Auth::ClientId.from_file('config/google/credentials.json')
    token_store = Google::Auth::Stores::FileTokenStore.new(file: 'config/google/tokens.yaml')
    authorizer = Google::Auth::UserAuthorizer.new(client_id, Google::Apis::CalendarV3::AUTH_CALENDAR, token_store)

    user_id = current_user.id.to_s
    credentials = authorizer.get_credentials(user_id)

    if credentials.nil?
      redirect_to authorizer.get_authorization_url(base_url: oauth2callback_url), allow_other_host: true
    else
      redirect_to tasks_path, notice: 'Googleアカウントはすでに認証済みです。'
    end
  end

  def callback
    client_id = Google::Auth::ClientId.from_file('config/google/credentials.json')
    token_store = Google::Auth::Stores::FileTokenStore.new(file: 'config/google/tokens.yaml')
    authorizer = Google::Auth::UserAuthorizer.new(client_id, Google::Apis::CalendarV3::AUTH_CALENDAR, token_store)

    user_id = current_user.id.to_s
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id,
      code: params[:code],
      base_url: oauth2callback_url
     )

    redirect_to tasks_path, notice: 'Googleカレンダー認証が完了しました！'
  end
end
