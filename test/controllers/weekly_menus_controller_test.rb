require "test_helper"

class WeeklyMenusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get weekly_menus_path
    assert_response :success
  end

  test "should get show" do
    get weekly_menu_path(1)
    assert_response :success
  end
end
