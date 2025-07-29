require "test_helper"

class PrivacyPoliciesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get privacy_policy_path
    assert_response :success
  end
end
