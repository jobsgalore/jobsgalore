class Location < ApplicationRecord

  @@default = nil

  has_many :client, dependent: :destroy
  has_many :company, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :deleted_job, dependent: :destroy
  has_many :experience, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :email_hr, dependent: :destroy


  def name
    @name ||= self.suburb + ', ' + self.state
  end

  def update_number_of_jobs

  end

  protected

  scope :search, ->(query = 'none') {where("locations.fts @@ to_tsquery('english',:query)",{query:query})}

  def self.major
    #@@major_city ||= select(:id,:suburb).where(suburb:["Sydney", "Melbourne", "Brisbane"]).all
    @major_city = select(:id,:suburb, :counts_jobs).where(suburb:["Sydney", "Melbourne", "Brisbane", "Gold Coast", "Perth", "Adelaide", "Hobart", "Darwin", "Canberra"]).order(counts_jobs: :desc)
  end



  def self.default
    @@default1 ||= find_by_suburb('Sydney')
  end


end
