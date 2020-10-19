require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "the index loads" do
    get root_url

    assert_response :success
    assert_equal "index", @controller.action_name
  end

  test "the guide page redirects to sign in" do
    get guide_url

    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test "signed in user have to return to index page after user_enable_authy_path" do
    user = users(:one)
    sign_in user

    get root_url

    assert_response :redirect
    assert_equal "index", @controller.action_name
   end

  test "signing in with a POST (not using Devise helper)" do
    user = users(:one)
    get '/users/sign_in'
    csrf_token = form_authenticity_token(response.body)

    post '/users/sign_in', params: {
      authenticity_token: csrf_token,
      user: { email: user.email, phone: '+15551115511', password: 'testpass' }
    }

    assert_response :redirect
    assert_redirected_to root_url
  end

  test "with a signed in user the guide page loads" do
    user = users(:one)
    sign_in user

    get guide_url

    assert_response :success
    assert_equal "guide", @controller.action_name
  end
end
