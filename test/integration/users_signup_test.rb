require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: {name: "", email: "usr@invalid", password: "foo", password_confirmation: "bar" } }
    end
    assert_template "users/new"
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
    assert_select 'form[action="/signup"]'
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: {name: "Example User", email: "foo@bar.com", password: "foobar", password_confirmation: "foobar"}}
    end
    follow_redirect!
    # assert_template 'users/show'
    assert flash.any?
    # assert is_logged_in?
  end

end
