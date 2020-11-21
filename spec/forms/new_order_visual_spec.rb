require 'rails_helper'
require "helpers/payments_helper"


describe NewOrderVisual  do

  #Заполнение справочников и инициализируем валюту
  before( :all) do
    FactoryBot.create(:product_urgent)
    FactoryBot.create(:product_highlight)
    FactoryBot.create(:product_urgent_and_highlight)
  end

  context "for job" do

    before( :context) do
      @order = NewOrderVisual.new(type: 'job', id: FactoryBot.create( :any_job).id, ip:'176.59.129.149')
    end
    #Проверка вновь созданного экземпляра для работы
    describe  "a new order" do
      it "should be a job" do
        expect(@order.job?).to eq(true)
      end

      it "should not be a resume" do
        expect(@order.resume?).to eq(false)
      end

      it "should have a current :RUB" do
        expect(@order.current).to eq(:RUB)
      end

      it "should have 3 prices" do
        expect(@order.urgent_price).not_to be_nil
        expect(@order.highlight_price).not_to be_nil
        expect(@order.urgent_and_highlight_price).not_to be_nil
      end

      it "should have an id" do
        expect(@order.id).not_to be_nil
      end

      it "should have a type" do
        expect(@order.type).to eq(:job)
      end

      it "should set an urgent tag" do
        @order.set_product("urgent")
        expect(@order.urgent).to eq(true)
        expect(@order.highlight).to eq(false)
        expect(@order.product).not_to be_nil
        expect(@order.price).not_to be_nil
      end

      it "should set an highlight tag" do
        @order.set_product("highlight")
        expect(@order.urgent).to eq(false)
        expect(@order.highlight).to eq(true)
        expect(@order.product).not_to be_nil
        expect(@order.price).not_to be_nil
      end

      it "should set urgent and highlight tags" do
        @order.set_product("urgent_and_highlight")
        expect(@order.urgent).to eq(true)
        expect(@order.highlight).to eq(true)
        expect(@order.product).not_to be_nil
        expect(@order.price).not_to be_nil
      end
    end

    #Задаем продукт и сохраняем заказ для работы
    describe  "save job " do
      describe "should save and create order for add tag an urgent in a job ad" do
        before(:all) do
          @order.set_product("urgent")
          @order.save
        end

        it 'should create an order with product_id like in the select form' do
          puts @order.order.params
          expect(@order.order.product_id).to eq(@order.product.id)
        end

        it 'should create an order with a param with urgent' do
          expect(@order.order.params.count).to eq(1)
          expect(@order.order.params.first).to eq({"type"=>"job", "id"=>1, "option"=>"urgent"})
        end
      end

      describe "should save and create order for add tag a highlight in a job ad" do

        before(:all) do
          @order.set_product("highlight")
          @order.save
        end

        it 'should create an order with a param with highlight' do
          expect(@order.order.params.count).to eq(1)
          expect(@order.order.params.first).to eq({"type"=>"job", "id"=>1, "option"=>"highlight"})
        end
      end

      describe "should save and create order for add tags highlight and  urgent in a job ad" do
        before(:all) do
          @order.set_product("urgent_and_highlight")
          @order.save
        end

        it 'should create an order with paramы with urgent and highlight' do
          expect(@order.order.params.count).to eq(2)
          expect(@order.order.params[0]).to eq({"type"=>"job", "id"=>1, "option"=>"urgent"})
          expect(@order.order.params[1]).to eq({"type"=>"job", "id"=>1, "option"=>"highlight"})
        end
      end
    end

  end



=begin
  it "should set product_id" do

  end
=end



end