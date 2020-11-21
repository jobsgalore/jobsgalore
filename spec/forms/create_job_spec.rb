require 'rails_helper'

describe CreateJob  do
  let(:city) { FactoryBot.create :location_omsk }
  let(:object) {  FactoryBot.build :create_job, location_id:city.id }
  let(:empty_object) {  described_class.new  }
  before(:all) do
    FactoryBot.create(:size)
    FactoryBot.create(:industry)
  end
  context 'validation' do
    it 'validates empty fields' do
      empty_object.valid?
      empty_object.errors.full_messages.each do |massage|
        expect(massage).to include('Email')
                               .or include('Password')
                                       .or include('Company')
                                               .or include('City')
                                                       .or include('Title')
                                                               .or include('Full name')
        expect(massage).to include("can't be blank")
      end
    end

    it 'validates email uniqueness' do
      object.email = FactoryBot.create(:client, location_id: city.id).email
      object.valid?
      expect(object.errors.full_messages).to include('This email address is already in use')
    end

    it 'validates company uniqueness' do
      object.company_name = FactoryBot.create(:company, location_id: city.id).name
      object.valid?
      expect(object.errors.full_messages).to include('This company name is already in use')
    end

    it 'validates company uniqueness when user is applicant' do
      object.type = :is_applicant
      object.company_name = FactoryBot.create(:company, location_id: city.id).name
      object.valid?
      expect(object.errors.full_messages).to include('This company name is already in use')
    end

  end

  it "should create a new client, a company and a new job"  do
    company, client, job = object.save.values
    expect(company.present?).to eq(true)
    expect(client.present?).to eq(true)
    expect(job.present?).to eq(true)
  end

  it "should create a company, a new job and changes type of client"  do
    user = FactoryBot.create(:client, character: 'applicant', location_id: city.id)
    object.type = :is_applicant
    company, client, job = object.save(user).values
    expect(company.present?).to eq(true)
    expect(client.character).to eq('employer')
    expect(job.present?).to eq(true)
  end

  it "should create only a new job"  do
    company = FactoryBot.create(:company, location_id: city.id)
    user = FactoryBot.create(:client, location_id: city.id, company_id: company.id)
    object.type = :is_employer
    _, _, job = object.save(user).values
    expect(job.present?).to eq(true)
  end


end

