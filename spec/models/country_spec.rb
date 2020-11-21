require 'rails_helper'

describe Country do

  it 'should get currency RUB' do
    expect(Country.currency_by_country('176.59.129.149')).to eq(:RUB)
  end
end