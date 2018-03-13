require 'test_helper'

class Api::ChestBoxsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_chest_boxs_index_url
    assert_response :success
  end

end
