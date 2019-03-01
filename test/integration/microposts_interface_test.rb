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
    assert_select 'input[type="file"]'
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
  
  test "valid micropost submission" do
    # Logging in
    log_in_as(@user)
    get root_url
    
    # Valid submission
    content = "Only one jour left until sunset"
    picture = fixture_file_upload('test/fixtures/files/kitten.jpg','image/jpg', :binary )
    assert_difference "Micropost.count", 1 do
      post microposts_path, params: {micropost: {content: content, picture: picture}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
  end
  
  test "post deletion" do
    # Logging in
    log_in_as(@user)
    get root_url
    
    # Delete post
    assert_select 'a', text: "delete"
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference "Micropost.count", -1 do
      delete micropost_path(first_micropost)
    end
  end
  
  test "no delete link on other user's page" do
    # Logging in
    log_in_as(@user)
    get root_url
    
    # Visit different user page
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
  
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_url
    assert_match "#{@user.microposts.count} microposts", response.body
  end
  
  test "micropost sidebar count with 0 post" do
    other_user = users(:malory)
    log_in_as(other_user)
    get root_url
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "ARCHEEEER!")
    get root_url
    assert_match "1 micropost", response.body
  end  
  
  
end
