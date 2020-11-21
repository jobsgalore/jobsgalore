=begin
require 'test_helper'

class SkillsresumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @skillsresume = skillsresumes(:one)
  end

  test "should get index" do
    get skillsresumes_url
    assert_response :success
  end

  test "should get new" do
    get new_skillsresume_url
    assert_response :success
  end

  test "should create skillsresume" do
    assert_difference('Skillsresume.count') do
      post skillsresumes_url, params: { skillsresume: { level_id: @skillsresume.level_id, name: @skillsresume.name, resume_id: @skillsresume.resume_id } }
    end

    assert_redirected_to skillsresume_url(Skillsresume.last)
  end

  test "should show skillsresume" do
    get skillsresume_url(@skillsresume)
    assert_response :success
  end

  test "should get edit" do
    get edit_skillsresume_url(@skillsresume)
    assert_response :success
  end

  test "should update skillsresume" do
    patch skillsresume_url(@skillsresume), params: { skillsresume: { level_id: @skillsresume.level_id, name: @skillsresume.name, resume_id: @skillsresume.resume_id } }
    assert_redirected_to skillsresume_url(@skillsresume)
  end

  test "should destroy skillsresume" do
    assert_difference('Skillsresume.count', -1) do
      delete skillsresume_url(@skillsresume)
    end

    assert_redirected_to skillsresumes_url
  end
end
=end
