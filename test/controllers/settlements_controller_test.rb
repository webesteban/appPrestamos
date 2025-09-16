require "test_helper"

class SettlementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get settlements_index_url
    assert_response :success
  end
end
