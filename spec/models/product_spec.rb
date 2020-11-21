require 'rails_helper'


describe Product do

  before( :all) do
    @product = FactoryBot.create(:product)
    @found_product = Product.find_by_type_and_option(type: "Resume", urgent:true,  highlight:true)
  end

  it "should find a product" do
    expect(@product).to eq(@found_product)
  end

  it 'should get a sum' do
    sum = @found_product.price_by_currency('EUR')
    expect(sum > 2).to eq(true)
  end

end