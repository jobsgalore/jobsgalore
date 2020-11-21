=begin
require 'test_helper'

class IndustryresumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @industryresume = industryresumes(:one)
  end

  test "should get index" do
    get industryresumes_url
    assert_response :success
  end

  test "should get new" do
    get new_industryresume_url
    assert_response :success
  end

  test "should create industryresume" do
    assert_difference('Industryresume.count') do
      post industryresumes_url, params: { industryresume: { industry_id: @industryresume.industry_id, resume_id: @industryresume.resume_id } }
    end

    assert_redirected_to industryresume_url(Industryresume.last)
  end

  test "should show industryresume" do
    get industryresume_url(@industryresume)
    assert_response :success
  end

  test "should get edit" do
    get edit_industryresume_url(@industryresume)
    assert_response :success
  end

  test "should update industryresume" do
    patch industryresume_url(@industryresume), params: { industryresume: { industry_id: @industryresume.industry_id, resume_id: @industryresume.resume_id } }
    assert_redirected_to industryresume_url(@industryresume)
  end

  test "should destroy industryresume" do
    assert_difference('Industryresume.count', -1) do
      delete industryresume_url(@industryresume)
    end

    assert_redirected_to industryresumes_url
  end
end
=end
