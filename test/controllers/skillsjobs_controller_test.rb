=begin
require 'test_helper'

class SkillsjobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @skillsjob = skillsjobs(:one)
  end

  test "should get index" do
    get skillsjobs_url
    assert_response :success
  end

  test "should get new" do
    get new_skillsjob_url
    assert_response :success
  end

  test "should create skillsjob" do
    assert_difference('Skillsjob.count') do
      post skillsjobs_url, params: { skillsjob: { job_id: @skillsjob.job_id, level_id: @skillsjob.level_id, name: @skillsjob.name } }
    end

    assert_redirected_to skillsjob_url(Skillsjob.last)
  end

  test "should show skillsjob" do
    get skillsjob_url(@skillsjob)
    assert_response :success
  end

  test "should get edit" do
    get edit_skillsjob_url(@skillsjob)
    assert_response :success
  end

  test "should update skillsjob" do
    patch skillsjob_url(@skillsjob), params: { skillsjob: { job_id: @skillsjob.job_id, level_id: @skillsjob.level_id, name: @skillsjob.name } }
    assert_redirected_to skillsjob_url(@skillsjob)
  end

  test "should destroy skillsjob" do
    assert_difference('Skillsjob.count', -1) do
      delete skillsjob_url(@skillsjob)
    end

    assert_redirected_to skillsjobs_url
  end
end
=end
