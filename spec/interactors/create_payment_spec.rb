require 'rails_helper'

describe CreatePayment do

  it "should create an order" do
    expect(FactoryBot.create(:order_job)).to_not be_nil
  end

  def create_params
    CreatePayment.call(params: {
        :mc_gross => "10.00",
        :settle_amount => "425.07",
        :protection_eligibility => "Eligible",
        :address_status => "confirmed",
        :payer_id => "BH858Z3RZD3SA",
        :address_street => "Voroshilova 69 a",
        :payment_date => "01:29:50 Jan 21, 2019 PST",
        :payment_status => "Completed",
        :charset =>"KOI8_R",
        :address_zip =>"72316",
        :first_name =>"Sergey",
        :mc_fee =>"0.79",
        :address_country_code =>"UA",
        :exchange_rate =>"46.1533",
        :address_name =>"Sergey",
        :notify_version =>"3.9",
        :settle_currency =>"RUB",
        :custom =>"",
        :payer_status =>"verified",
        :business =>"",
        :address_country =>"",
        :address_city =>"Melitopol",
        :quantity =>"1",
        :verify_sign =>"A0.lgvS9LTcPk",
        :payer_email =>"p3424322ole@gmail.com",
        :txn_id =>"2NW74sdffdsf8",
        :payment_type =>"instant",
        :last_name =>"",
        :address_state =>"",
        :receiver_email =>"",
        :payment_fee =>"",
        :shipping_discount =>"0.00",
        :insurance_amount =>"0.00",
        :receiver_id =>"dsgsfR3RG",
        :txn_type =>"web_accept",
        :item_name =>"Urgent",
        :discount =>"0.00",
        :mc_currency =>"AUD",
        :item_number =>"55#{@order.id}",
        :residence_country =>"UA",
        :shipping_method =>"Default",
        :transaction_subject =>"",
        :payment_gross =>"",
        :ipn_track_id =>"f50f7701bbdc9",
        :controller => "payments",
        :action => "create"
    })
  end

  describe "should create a payment for order(only urgent)"  do

    before(:all) do
      @job = FactoryBot.create(:any_job)
      @order = FactoryBot.create(:order_job)
      @order.update( params: [{"type"=>"job", "id"=>@job.id, "option"=>"urgent"}])
      create_params
    end

    it "should urgent a job" do
      expect(Job.find_by_id(@job.id).urgent.present?).to be_truthy
    end

    it "should not highlight a job" do
      expect(Job.find_by_id(@job.id).highlight.present?).to be_falsey
    end

    it "should change state of a order from expect_the_payment  to finished" do
      order = Order.find_by_id(@order.id)
      expect(order.aasm_state).to eq('finished')
      expect(order.payment_id).to_not be_nil
    end
  end

  describe "should create a payment for order(only highlight)"  do

    before(:all) do
      @job = FactoryBot.create(:any_job)
      @order = FactoryBot.create(:order_job)
      @order.update( params: [{"type"=>"job", "id"=>@job.id, "option"=>"highlight"}])
      create_params
    end

    it "should not urgent a job" do
      expect(Job.find_by_id(@job.id).urgent.present?).to be_falsey
    end

    it "should highlight a job" do
      expect(Job.find_by_id(@job.id).highlight.present?).to be_truthy
    end

    it "should change state of a order from expect_the_payment  to finished" do
      order = Order.find_by_id(@order.id)
      expect(order.aasm_state).to eq('finished')
      expect(order.payment_id).to_not be_nil
    end
  end

  describe "should create a payment with error"  do

    before(:all) do
      @job = FactoryBot.create(:any_job)
      @order = FactoryBot.create(:order_job)
      @order.update( params: [{"type"=>"job", "id"=>@job.id, "option"=>"urgent_and_highlight"}])
      create_params
    end

    it "should change state of a order from expect_the_payment  to finished" do
      order = Order.find_by_id(@order.id)
      expect(order.aasm_state).to eq('error')
      expect(order.params[1]).to_not be_nil
      expect(order.payment_id).to_not be_nil
    end
  end

  describe "should create a payment for order(urgent and highlight)"  do

    before(:all) do
      @job = FactoryBot.create(:any_job)
      @order = FactoryBot.create(:order_job)
      @order.update( params:
                         [{"type"=>"job", "id"=>@job.id, "option"=>"highlight"},
                          {"type"=>"job", "id"=>@job.id, "option"=>"urgent"}])
      create_params
    end

    it "should not urgent a job" do
      expect(Job.find_by_id(@job.id).urgent.present?).to be_truthy
    end

    it "should highlight a job" do
      expect(Job.find_by_id(@job.id).highlight.present?).to be_truthy
    end

    it "should change state of a order from expect_the_payment  to finished" do
      order = Order.find_by_id(@order.id)
      expect(order.aasm_state).to eq('finished')
      expect(order.payment_id).to_not be_nil
    end
  end

end