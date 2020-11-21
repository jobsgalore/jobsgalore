=begin
require 'test_helper'

class PropertsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @propert = properts(:one)
  end

  test "should get index" do
    get properts_url
    assert_response :success
  end

  test "should get new" do
    get new_propert_url
    assert_response :success
  end

  test "should create propert" do
    assert_difference('Propert.count') do
      post properts_url, params: { propert: { code: @propert.code, name: @propert.name, value: @propert.value } }
    end

    assert_redirected_to propert_url(Propert.last)
  end

  test "should show propert" do
    get propert_url(@propert)
    assert_response :success
  end

  test "should get edit" do
    get edit_propert_url(@propert)
    assert_response :success
  end

  test "should update propert" do
    patch propert_url(@propert), params: { propert: { code: @propert.code, name: @propert.name, value: @propert.value } }
    assert_redirected_to propert_url(@propert)
  end

  test "should destroy propert" do
    assert_difference('Propert.count', -1) do
      delete propert_url(@propert)
    end

    assert_redirected_to properts_url
  end
end
=end
