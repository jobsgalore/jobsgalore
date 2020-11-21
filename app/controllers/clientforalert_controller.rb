# frozen_string_literal: true

class ClientforalertController < ApplicationController
  before_action :set_client, only: [:unsubscribe]

  def create
    param = clientforalert_params
    user = Clientforalert.where(email: param[:email]).first_or_initialize
    user.key = param[:key]
    user.location_id = param[:location_id]
    user.save
  end

  def unsubscribe
    @client.update(send_email: !@client.send_email)
    redirect_to root_path, notice: 'Your alert has been cancelled!'
  end

  private

  def clientforalert_params
    params.require(:clientforalert).permit(:email, :key, :location_id)
  end

  def set_client
    @client = Clientforalert.find(params[:id])
  end

end
