require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest
=begin
  setup do
    @client = Client.first
  end

  test "should get index" do
    get clients_url
    assert_response :success
  end
=end

=begin
  test "should get new" do
    get new_client_url
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post clients_url, params: { client: {email: @client.email, firstname: @client.firstname, gender: @client.gender, lastname: @client.lastname, location_id: @client.location_id, password: @client.password, phone: @client.phone, photo_uid: @client.photo, resp: @client.responsible } }
    end

    assert_redirected_to client_url(Client.last)
  end

  test "should show client" do
    get client_url(@client)
    assert_response :success
  end

  test "should get edit" do
    get edit_client_url(@client)
    assert_response :success
  end

  test "should update client" do
    patch client_url(@client), params: { client: {email: @client.email, firstname: @client.firstname, gender: @client.gender, lastname: @client.lastname, location_id: @client.location_id, password: @client.password, phone: @client.phone, photo_uid: @client.photo, resp: @client.responsible } }
    assert_redirected_to client_url(@client)
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete client_url(@client)
    end

    assert_redirected_to clients_url
  end
=end
end
