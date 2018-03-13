require 'test_helper'

class ChestRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chest_records_index_url
    assert_response :success
  end

end
