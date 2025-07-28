require 'rails_helper'

RSpec.describe 'WeeklyMenus', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:user, :with_diet_plan) }
  let(:plan) { user.plan }

  def sign_in_user(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password123'
    click_button 'ログイン'
  end

  def sign_out_user
    visit destroy_user_session_path
  end

  describe 'Calendar view' do
    let!(:monday_menu) { create(:weekly_menu, :monday_chest, plan: plan) }
    let!(:tuesday_menu) { create(:weekly_menu, :tuesday_back, plan: plan) }

    before do
      sign_in_user(user)
    end

    it 'displays the calendar with weekly menus' do
      visit weekly_menus_path

      expect(page).to have_content(user.plan.title)
      expect(page).to have_content(Date.current.strftime('%Y年%m月'))

      # Check for calendar grid
      expect(page).to have_css('.calendar-grid')
      expect(page).to have_content('日')
      expect(page).to have_content('月')
      expect(page).to have_content('火')
      expect(page).to have_content('水')
      expect(page).to have_content('木')
      expect(page).to have_content('金')
      expect(page).to have_content('土')
    end

    it 'shows workout details in calendar cells' do
      visit weekly_menus_path

      # Should show workout names in calendar
      expect(page).to have_content(monday_menu.name)
      expect(page).to have_content(monday_menu.description)
    end

    it 'allows navigation between months' do
      visit weekly_menus_path

      # Navigate to next month
      click_link '次月'
      expect(page).to have_content((Date.current + 1.month).strftime('%Y年%m月'))

      # Navigate back to previous month
      click_link '前月'
      expect(page).to have_content(Date.current.strftime('%Y年%m月'))
    end
  end

  describe 'Creating a new weekly menu' do
    before do
      sign_in_user(user)
    end

    it 'allows user to create a new weekly menu' do
      visit new_weekly_menu_path

      fill_in 'weekly_menu_name', with: 'テスト用ワークアウト'
      fill_in 'weekly_menu_description', with: 'テスト用の詳細説明'
      fill_in 'weekly_menu_scheduled_date', with: Date.current.strftime('%Y-%m-%d')

      click_button 'Create Weekly menu'

      expect(page).to have_content('テスト用ワークアウト')
      expect(page).to have_content('テスト用の詳細説明')
      expect(page).to have_content('Weekly menu was successfully created')
    end

    it 'shows validation errors for invalid input' do
      visit new_weekly_menu_path

      # Submit form with empty fields
      click_button 'Create Weekly menu'

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Description can't be blank")
    end
  end

  describe 'Viewing a weekly menu' do
    let!(:weekly_menu) { create(:weekly_menu, plan: plan) }

    before do
      sign_in_user(user)
    end

    it 'displays the weekly menu details' do
      visit weekly_menu_path(weekly_menu)

      expect(page).to have_content(weekly_menu.name)
      expect(page).to have_content(weekly_menu.description)
      expect(page).to have_content(weekly_menu.scheduled_date.strftime('%Y年%m月%d日'))
    end

    it 'has edit and delete links' do
      visit weekly_menu_path(weekly_menu)

      expect(page).to have_link('Edit')
      expect(page).to have_link('Delete')
    end
  end

  describe 'Editing a weekly menu' do
    let!(:weekly_menu) { create(:weekly_menu, plan: plan) }

    before do
      sign_in_user(user)
    end

    it 'allows user to update a weekly menu' do
      visit edit_weekly_menu_path(weekly_menu)

      fill_in 'weekly_menu_name', with: '更新されたワークアウト'
      fill_in 'weekly_menu_description', with: '更新された詳細説明'

      click_button 'Update Weekly menu'

      expect(page).to have_content('更新されたワークアウト')
      expect(page).to have_content('更新された詳細説明')
      expect(page).to have_content('Weekly menu was successfully updated')
    end

    it 'shows validation errors for invalid updates' do
      visit edit_weekly_menu_path(weekly_menu)

      fill_in 'weekly_menu_name', with: ''
      fill_in 'weekly_menu_description', with: ''

      click_button 'Update Weekly menu'

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Description can't be blank")
    end
  end

  describe 'Deleting a weekly menu' do
    let!(:weekly_menu) { create(:weekly_menu, plan: plan) }

    before do
      sign_in_user(user)
    end

    it 'allows user to delete a weekly menu', js: true do
      visit weekly_menu_path(weekly_menu)

      accept_confirm do
        click_link 'Delete'
      end

      expect(page).to have_content('Weekly menu was successfully deleted')
      expect(page).not_to have_content(weekly_menu.name)
    end
  end

  describe 'Plan-specific menus' do
    let(:health_plan) { create(:plan, :health_maintenance) }
    let(:diet_plan) { create(:plan, :diet) }
    let(:muscle_plan) { create(:plan, :muscle_building) }

    let!(:health_menu) { create(:weekly_menu, plan: health_plan, name: 'ライトトレーニング') }
    let!(:diet_menu) { create(:weekly_menu, plan: diet_plan, name: 'ダイエット メニュー') }
    let!(:muscle_menu) { create(:weekly_menu, plan: muscle_plan, name: 'マッスル メニュー') }

    it 'shows only current user plan menus' do
      # User with diet plan should only see diet menus
      user.update!(plan: diet_plan)
      sign_in_user(user)
      visit weekly_menus_path

      expect(page).to have_content('ダイエット メニュー')
      expect(page).not_to have_content('ライトトレーニング')
      expect(page).not_to have_content('マッスル メニュー')
    end

    it 'updates menus when user changes plan' do
      # User switches to muscle building plan
      user.update!(plan: muscle_plan)
      sign_in_user(user)
      visit weekly_menus_path

      expect(page).to have_content('マッスル メニュー')
      expect(page).not_to have_content('ダイエット メニュー')
      expect(page).not_to have_content('ライトトレーニング')
    end
  end

  describe 'Authentication' do
    it 'redirects to sign in when not authenticated' do
      visit weekly_menus_path

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('ログイン')
    end

    it 'allows access after signing in' do
      visit weekly_menus_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password123'
      click_button 'ログイン'

      # ApplicationControllerの設定により、ログイン後はマイページにリダイレクトされる
      expect(page).to have_current_path(mypage_path)
      # その後、weekly_menusページに直接アクセスできることを確認
      visit weekly_menus_path
      expect(page).to have_content(user.plan.title)
    end
  end
end
