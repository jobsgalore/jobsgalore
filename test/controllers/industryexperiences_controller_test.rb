=begin
require 'test_helper'

class IndustryexperiencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @industryexperience = industryexperiences(:one)
  end

  test "should get index" do
    get industryexperiences_url
    assert_response :success
  end

  test "should get new" do
    get new_industryexperience_url
    assert_response :success
  end

  test "should create industryexperience" do
    assert_difference('Industryexperience.count') do
      post industryexperiences_url, params: { industryexperience: { experience_id: @industryexperience.experience_id, industry_id: @industryexperience.industry_id } }
    end

    assert_redirected_to industryexperience_url(Industryexperience.last)
  end

  test "should show industryexperience" do
    get industryexperience_url(@industryexperience)
    assert_response :success
  end

  test "should get edit" do
    get edit_industryexperience_url(@industryexperience)
    assert_response :success
  end

  test "should update industryexperience" do
    patch industryexperience_url(@industryexperience), params: { industryexperience: { experience_id: @industryexperience.experience_id, industry_id: @industryexperience.industry_id } }
    assert_redirected_to industryexperience_url(@industryexperience)
  end

  test "should destroy industryexperience" do
    assert_difference('Industryexperience.count', -1) do
      delete industryexperience_url(@industryexperience)
    end

    assert_redirected_to industryexperiences_url
  end
end
=end
