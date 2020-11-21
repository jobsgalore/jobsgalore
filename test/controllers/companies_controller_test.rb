require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = Company.first
  end



=begin
  test "should create company" do
    assert_difference('Company.count') do
      post companies_url, params: { company: {description: @company.description, location_id: @company.location_id, logo_uid: @company.logo, name: @company.name, realy: @company.realy, recrutmentagency: @company.recrutmentagency, site: @company.site, size_id: @company.size_id } }
    end

    assert_redirected_to company_url(Company.last)
  end
=end

  test "should show company" do
    get company_path(@company)
    assert_response :success
  end
=begin

  test "should get edit" do
    get edit_company_url(@company)
    assert_response :success
  end

  test "should update company" do
    patch company_url(@company), params: { company: {description: @company.description, location_id: @company.location_id, logo_uid: @company.logo, name: @company.name, realy: @company.realy, recrutmentagency: @company.recrutmentagency, site: @company.site, size_id: @company.size_id } }
    assert_redirected_to company_url(@company)
  end

  test "should destroy company" do
    assert_difference('Company.count', -1) do
      delete company_url(@company)
    end

    assert_redirected_to companies_url
  end
=end
end
