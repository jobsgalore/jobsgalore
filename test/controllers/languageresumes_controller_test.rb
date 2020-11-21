=begin
require 'test_helper'

class LanguageresumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @languageresume = languageresumes(:one)
  end

  test "should get index" do
    get languageresumes_url
    assert_response :success
  end

  test "should get new" do
    get new_languageresume_url
    assert_response :success
  end

  test "should create languageresume" do
    assert_difference('Languageresume.count') do
      post languageresumes_url, params: { languageresume: { language_id: @languageresume.language_id, level_id: @languageresume.level_id, resume_id: @languageresume.resume_id } }
    end

    assert_redirected_to languageresume_url(Languageresume.last)
  end

  test "should show languageresume" do
    get languageresume_url(@languageresume)
    assert_response :success
  end

  test "should get edit" do
    get edit_languageresume_url(@languageresume)
    assert_response :success
  end

  test "should update languageresume" do
    patch languageresume_url(@languageresume), params: { languageresume: { language_id: @languageresume.language_id, level_id: @languageresume.level_id, resume_id: @languageresume.resume_id } }
    assert_redirected_to languageresume_url(@languageresume)
  end

  test "should destroy languageresume" do
    assert_difference('Languageresume.count', -1) do
      delete languageresume_url(@languageresume)
    end

    assert_redirected_to languageresumes_url
  end
end
=end
