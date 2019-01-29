require 'test_helper'

class LookingRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @looking_request = looking_requests(:one)
  end

  test "should get index" do
    get looking_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_looking_request_url
    assert_response :success
  end

  test "should create looking_request" do
    assert_difference('LookingRequest.count') do
      post looking_requests_url, params: { looking_request: {  } }
    end

    assert_redirected_to looking_request_url(LookingRequest.last)
  end

  test "should show looking_request" do
    get looking_request_url(@looking_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_looking_request_url(@looking_request)
    assert_response :success
  end

  test "should update looking_request" do
    patch looking_request_url(@looking_request), params: { looking_request: {  } }
    assert_redirected_to looking_request_url(@looking_request)
  end

  test "should destroy looking_request" do
    assert_difference('LookingRequest.count', -1) do
      delete looking_request_url(@looking_request)
    end

    assert_redirected_to looking_requests_url
  end
end
