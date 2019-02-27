require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end
  
  test "user id should be present on the micropost" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  test "content should not be empty" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end
  
  test "content should not exceed 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
  test "should be the most recent post first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
  
end
