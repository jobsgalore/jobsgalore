require 'rails_helper'

describe CreateJobService do

  let(:city) { FactoryBot.create(:location_omsk) }
  let(:client) { FactoryBot.create(:client, location_id: city.id) }
  let(:company) { FactoryBot.create(:company, location_id: city.id) }
  let(:params) do
    {
        full_name: 'Nikol Kidman',
        email: 'nikol.k@mail.com',
        location_id: city.id,
        location_name: city.suburb,
        title: "New jobs",
        salarymin: 1,
        salarymax: 1000,
        description: "<p>Description of job</p>",
        password: 111111,
        company_name: "Good company"
    }
  end

  it 'is a first time' do
    service = described_class.call(params: params, client: nil)
    expect(service).to be_a_success
  end

  it 'is an applicant' do
    client.character = TypeOfClient::APPLICANT
    service = described_class.call(params: params, client: client)
    expect(service).to be_a_success
  end

  it 'is an employer' do
    client.update(company: company)
    service = described_class.call(params: params, client: client)
    expect(service).to be_a_success
  end

  it 'fails' do
    params[:full_name] = nil
    service = described_class.call(params: params, client: nil)
    expect(service).to be_a_failure
  end

end