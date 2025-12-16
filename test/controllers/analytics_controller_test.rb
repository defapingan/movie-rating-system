require "test_helper"

class AnalyticsControllerTest < ActionDispatch::IntegrationTest
  test "should get analytics page" do
    get analytics_path
    assert_response :success
    assert_select "h1", "Data Analytics"
  end
end
