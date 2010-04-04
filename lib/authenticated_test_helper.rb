module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    if user.is_a?(Symbol)
      user = create_activated_user
    elsif user.is_a?(Hash)
      user = create_activated_user(user)
    end
    @request.session[:user_id] = user ? user : nil
  end

  def authorize_as(user)
    if user.is_a?(Symbol)
      user = create_activated_user
    elsif user.is_a?(Hash)
      user = create_activated_user(user)
    end
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(user.login, 'password') : nil
  end

  # rspec
  def mock_user
    user = mock_model(User, :id => 1,
      :login  => 'user_name',
      :name   => 'U. Surname',
      :to_xml => "User-in-XML", :to_json => "User-in-JSON",
      :errors => [])
    user
  end
end
