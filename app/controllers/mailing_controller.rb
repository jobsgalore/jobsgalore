class MailingController < ApplicationController

  before_action :set_company, only: :contacts_of_companies
  before_action :set_mailing, only: :destroy
  before_action :authenticate_client!, only: [:contacts_of_companies, :show, :destroy]

  def contacts_of_companies
    @price = Mailing.price(request.remote_ip)
    @amount = 0
    @elements = (Client.all_for_view + EmailHr.all_for_view).map.with_index do |row, index|
      {index: index,
       type_client: row['type_client'],
       check: consider(row['company']),
       id: row['id'],
       company: row['company'],
       office: row['office'],
       main:row['main'],
       recrutmentagency: row['recrutmentagency'],
       industry:row['industry'],
       location:row['location'] ? row['location'] : 'Australia'}
    end
  end

  def create
    letter = CreateLetter.call(params:params, client: current_client.id)
    render json:  {url: letter.payment_url}, status: :ok
  end

  def destroy
    @mailing.destroy
    render json: { message: "done" }, status: :ok
  end

  def show
    @mailings = Mailing.where(client_id: current_client).order(created_at: :desc).limit(20).decorate.map do |t|
      res = t.to_h
      res[:destroy_url] = mailing_url(t.id)
      res[:pay_url] = t.payment_url
      res
    end

  end

  private
  def consider(name)
    if @filter ==  name
      @amount +=1
      true
    else
      false
    end
  end

  def set_company
    @filter = params[:name]
  end

  def set_mailing
    @mailing =  Mailing.find(params[:id])
  end



end