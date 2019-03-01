require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end
  
  test "microposts feed is properly paginated" do
    # Logging in
    log_in_as(@user)
    get root_url
    assert_select 'div.pagination'
  end
  
  test "invalid micropost submission" do
    # Logging in
    log_in_as(@user)
    get root_url
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: ""}}
    end
    assert_select 'div#error_explanation'
  end
end
