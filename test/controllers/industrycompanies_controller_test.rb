=begin
require 'test_helper'

class IndustrycompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @industrycompany = industrycompanies(:one)
  end

  test "should get index" do
    get industrycompanies_url
    assert_response :success
  end

  test "should get new" do
    get new_industrycompany_url
    assert_response :success
  end

  test "should create industrycompany" do
    assert_difference('Industrycompany.count') do
      post industrycompanies_url, params: { industrycompany: { company_id: @industrycompany.company_id, industry_id: @industrycompany.industry_id } }
    end

    assert_redirected_to industrycompany_url(Industrycompany.last)
  end

  test "should show industrycompany" do
    get industrycompany_url(@industrycompany)
    assert_response :success
  end

  test "should get edit" do
    get edit_industrycompany_url(@industrycompany)
    assert_response :success
  end

  test "should update industrycompany" do
    patch industrycompany_url(@industrycompany), params: { industrycompany: { company_id: @industrycompany.company_id, industry_id: @industrycompany.industry_id } }
    assert_redirected_to industrycompany_url(@industrycompany)
  end

  test "should destroy industrycompany" do
    assert_difference('Industrycompany.count', -1) do
      delete industrycompany_url(@industrycompany)
    end

    assert_redirected_to industrycompanies_url
  end
end
=end
