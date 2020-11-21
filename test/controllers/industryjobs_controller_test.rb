=begin
require 'test_helper'

class IndustryjobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @industryjob = industryjobs(:one)
  end

  test "should get index" do
    get industryjobs_url
    assert_response :success
  end

  test "should get new" do
    get new_industryjob_url
    assert_response :success
  end

  test "should create industryjob" do
    assert_difference('Industryjob.count') do
      post industryjobs_url, params: { industryjob: { industry_id: @industryjob.industry_id, job_id: @industryjob.job_id } }
    end

    assert_redirected_to industryjob_url(Industryjob.last)
  end

  test "should show industryjob" do
    get industryjob_url(@industryjob)
    assert_response :success
  end

  test "should get edit" do
    get edit_industryjob_url(@industryjob)
    assert_response :success
  end

  test "should update industryjob" do
    patch industryjob_url(@industryjob), params: { industryjob: { industry_id: @industryjob.industry_id, job_id: @industryjob.job_id } }
    assert_redirected_to industryjob_url(@industryjob)
  end

  test "should destroy industryjob" do
    assert_difference('Industryjob.count', -1) do
      delete industryjob_url(@industryjob)
    end

    assert_redirected_to industryjobs_url
  end
end
=end
