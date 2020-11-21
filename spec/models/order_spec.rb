require 'rails_helper'

describe Order do

  before(:each) do
    @order = Order.create(product_id: 1)
  end

  it "should create a new object with state 'expect_the_payment'" do
    expect(@order.aasm_state).to eq("expect_the_payment")
  end

  it "should create a new object product_id 1" do
    expect(@order.product_id).to eq(1)
  end

  it "should change state from expect_the_payment to error" do
    expect{@order.error}.to change { @order.aasm_state }.from('expect_the_payment').to('error')
  end

  it "should change state from expect_the_payment  to finished" do
    expect{@order.finish}.to change { @order.aasm_state }.from('expect_the_payment').to('finished')
  end

  it "should change state from error to finished" do
    @order.error
    expect{@order.finish}.to change { @order.aasm_state }.from('error').to('finished')
  end



end