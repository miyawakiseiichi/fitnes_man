require 'rails_helper'

RSpec.describe WeeklyMenusController, type: :controller do
  let(:user) { create(:user, :with_diet_plan) }
  let(:plan) { user.plan }
  let!(:weekly_menu) { create(:weekly_menu, plan: plan) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'when user is signed in' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'loads current user plan menus' do
        get :index
        expect(assigns(:plan_menus)).to be_present
      end

      it 'groups menus by day of week' do
        get :index
        menus_by_day = assigns(:menus_by_day)
        expect(menus_by_day).to be_present
      end

      context 'with date parameter' do
        it 'loads menus for specific date' do
          test_date = Date.current.beginning_of_month
          get :index, params: { date: test_date.strftime('%Y-%m-%d') }
          expect(response).to be_successful
          expect(assigns(:date)).to eq(test_date)
        end
      end

      context 'without date parameter' do
        it 'defaults to current date' do
          get :index
          expect(assigns(:date)).to eq(Date.current)
        end
      end
    end

    context 'when user is not signed in' do
      before { sign_out user }

      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when menu exists' do
      it 'returns a success response' do
        get :show, params: { id: weekly_menu.id }
        expect(response).to be_successful
        expect(assigns(:weekly_menu)).to eq(weekly_menu)
      end
    end

    context 'when menu does not exist' do
      it 'raises record not found' do
        expect {
          get :show, params: { id: 999999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
      expect(assigns(:weekly_menu)).to be_a_new(WeeklyMenu)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          name: '新しいワークアウト',
          description: 'テスト用のワークアウト',
          scheduled_date: Date.current,
          plan_id: plan.id
        }
      end

      it 'creates a new WeeklyMenu' do
        expect {
          post :create, params: { weekly_menu: valid_attributes }
        }.to change(WeeklyMenu, :count).by(1)
      end

      it 'redirects to the created weekly_menu' do
        post :create, params: { weekly_menu: valid_attributes }
        expect(response).to redirect_to(WeeklyMenu.last)
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
          post :create, params: { weekly_menu: invalid_attributes }
        }.not_to change(WeeklyMenu, :count)
      end

      it 'returns a success response (re-renders template)' do
        post :create, params: { weekly_menu: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: weekly_menu.id }
      expect(response).to be_successful
      expect(assigns(:weekly_menu)).to eq(weekly_menu)
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: '更新されたワークアウト',
          description: '更新されたDescription'
        }
      end

      it 'updates the requested weekly_menu' do
        patch :update, params: { id: weekly_menu.id, weekly_menu: new_attributes }
        weekly_menu.reload
        expect(weekly_menu.name).to eq('更新されたワークアウト')
        expect(weekly_menu.description).to eq('更新されたDescription')
      end

      it 'redirects to the weekly_menu' do
        patch :update, params: { id: weekly_menu.id, weekly_menu: new_attributes }
        expect(response).to redirect_to(weekly_menu)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          description: ''
        }
      end

      it 'returns a success response (re-renders template)' do
        patch :update, params: { id: weekly_menu.id, weekly_menu: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested weekly_menu' do
      expect {
        delete :destroy, params: { id: weekly_menu.id }
      }.to change(WeeklyMenu, :count).by(-1)
    end

    it 'redirects to the weekly_menus list' do
      delete :destroy, params: { id: weekly_menu.id }
      expect(response).to redirect_to(weekly_menus_url)
    end
  end
end 