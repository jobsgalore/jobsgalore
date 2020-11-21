=begin
require 'test_helper'

class IndustriesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin = users(:admin)
    @industry = Industry.first
  end

  test "should get index" do
    sign_in @admin, scope: :admin
    get industries_path
    assert_response :success
  end

  test "should get new" do
    get new_industry_path
    assert_response :success
  end

  test "should create industry" do
    assert_difference('Industry.count') do
      post industries_path, params: { industry: { level: @industry.level, name: @industry.name, parrent_id: @industry.parrent_id } }
    end

    assert_redirected_to industry_path(Industry.last)
  end

  test "should show industry" do
    get industry_path(@industry)
    assert_response :success
  end

  test "should get edit" do
    get edit_industry_path(@industry)
    assert_response :success
  end

  test "should update industry" do
    patch industry_path(@industry), params: { industry: { level: @industry.level, name: @industry.name, parrent_id: @industry.parrent_id } }
    assert_redirected_to industry_path(@industry)
  end

  test "should destroy industry" do
    assert_difference('Industry.count', -1) do
      delete industry_path(@industry)
    end

    assert_redirected_to industries_path
  end
end
=end
