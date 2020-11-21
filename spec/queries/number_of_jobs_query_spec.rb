require 'rails_helper'

describe NumberOfJobsQuery do

  let(:query){described_class.new}
  let(:number_of_jobs) do
    [:location_omsk, :location_moskow]
        .map{ |name | FactoryBot.create(name) }
        .pluck(:counts_jobs).reduce(:+)
  end

  it 'call sql query' do
    expect((number_of_jobs*1.3).to_i.to_s).to eq(query.call)
  end
end