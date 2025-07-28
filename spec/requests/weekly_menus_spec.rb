require 'rails_helper'

RSpec.describe '/weekly_menus', type: :request do
  let(:user) { create(:user, :with_diet_plan) }
  let(:plan) { user.plan }
  let!(:weekly_menu) { create(:weekly_menu, plan: plan) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get weekly_menus_url
      expect(response).to be_successful
      expect(response.body).to include('週次メニュー')
    end

    it 'displays current plan name' do
      get weekly_menus_url
      expect(response.body).to include(user.plan.title)
    end

    it 'includes calendar navigation' do
      get weekly_menus_url
      expect(response.body).to include('前月')
      expect(response.body).to include('次月')
    end

    context 'with date parameter' do
      it 'shows calendar for specified date' do
        test_date = Date.current.beginning_of_month
        get weekly_menus_url, params: { date: test_date.strftime('%Y-%m-%d') }
        expect(response).to be_successful
        expect(response.body).to include(test_date.strftime('%Y年%m月'))
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get weekly_menu_url(weekly_menu)
      expect(response).to be_successful
      expect(response.body).to include(weekly_menu.name)
      expect(response.body).to include(weekly_menu.description)
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_weekly_menu_url
      expect(response).to be_successful
      expect(response.body).to include('新規メニュー作成')
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_weekly_menu_url(weekly_menu)
      expect(response).to be_successful
      expect(response.body).to include('メニュー編集')
      expect(response.body).to include(weekly_menu.name)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          name: '新しいワークアウト',
          description: 'テスト用のワークアウト詳細',
          scheduled_date: Date.current,
          plan_id: plan.id
        }
      end

      it 'creates a new WeeklyMenu' do
        expect {
          post weekly_menus_url, params: { weekly_menu: valid_attributes }
        }.to change(WeeklyMenu, :count).by(1)
      end

      it 'redirects to the created weekly_menu' do
        post weekly_menus_url, params: { weekly_menu: valid_attributes }
        expect(response).to redirect_to(weekly_menu_url(WeeklyMenu.last))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          description: '',
          scheduled_date: nil
        }
      end

      it 'does not create a new WeeklyMenu' do
        expect {
          post weekly_menus_url, params: { weekly_menu: invalid_attributes }
        }.not_to change(WeeklyMenu, :count)
      end

      it 'renders a successful response (re-renders template)' do
        post weekly_menus_url, params: { weekly_menu: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: '更新されたワークアウト',
          description: '更新された詳細説明'
        }
      end

      it 'updates the requested weekly_menu' do
        patch weekly_menu_url(weekly_menu), params: { weekly_menu: new_attributes }
        weekly_menu.reload
        expect(weekly_menu.name).to eq('更新されたワークアウト')
        expect(weekly_menu.description).to eq('更新された詳細説明')
      end

      it 'redirects to the weekly_menu' do
        patch weekly_menu_url(weekly_menu), params: { weekly_menu: new_attributes }
        expect(response).to redirect_to(weekly_menu_url(weekly_menu))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          description: ''
        }
      end

      it 'renders a successful response (re-renders template)' do
        patch weekly_menu_url(weekly_menu), params: { weekly_menu: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested weekly_menu' do
      expect {
        delete weekly_menu_url(weekly_menu)
      }.to change(WeeklyMenu, :count).by(-1)
    end

    it 'redirects to the weekly_menus list' do
      delete weekly_menu_url(weekly_menu)
      expect(response).to redirect_to(weekly_menus_url)
    end
  end

  context 'when user is not signed in' do
    before do
      sign_out user
    end

    it 'redirects to sign in page for index' do
      get weekly_menus_url
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'redirects to sign in page for show' do
      get weekly_menu_url(weekly_menu)
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'redirects to sign in page for new' do
      get new_weekly_menu_url
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'redirects to sign in page for edit' do
      get edit_weekly_menu_url(weekly_menu)
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
