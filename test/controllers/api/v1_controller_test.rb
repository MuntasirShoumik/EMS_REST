require "test_helper"

class Api::V1ControllerTest < ActionDispatch::IntegrationTest
  test "should get employees" do
    get api_v1_employees_url
    assert_response :success
  end
end
