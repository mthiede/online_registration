require 'test_helper'

class RegistrationConfigsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registration_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration_config" do
    assert_difference('RegistrationConfig.count') do
      post :create, :registration_config => { }
    end

    assert_redirected_to registration_config_path(assigns(:registration_config))
  end

  test "should show registration_config" do
    get :show, :id => registration_configs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => registration_configs(:one).to_param
    assert_response :success
  end

  test "should update registration_config" do
    put :update, :id => registration_configs(:one).to_param, :registration_config => { }
    assert_redirected_to registration_config_path(assigns(:registration_config))
  end

  test "should destroy registration_config" do
    assert_difference('RegistrationConfig.count', -1) do
      delete :destroy, :id => registration_configs(:one).to_param
    end

    assert_redirected_to registration_configs_path
  end
end
