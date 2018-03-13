require 'test_helper'

class Api::ChestRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_chest_records_index_url
    assert_response :success
  end

end
