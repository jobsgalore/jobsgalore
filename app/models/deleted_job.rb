class DeletedJob < ApplicationRecord


  belongs_to :location
  belongs_to :company

  validates :original_id, presence: true
  validates :title, presence: true
  validates :company, presence: true
  validates :location, presence: true

  def to_job
    Job.new(
        id: original_id,
        title: title,
        location_id: location_id,
        salarymin: salarymin,
        salarymax: salarymax,
        description: description,
        created_at: self.begin,
        company_id: company_id,
        client: company.client.first,
        close: created_at,
        state: DELETED
    )
  end

end
