class Experience < ApplicationRecord
  belongs_to :location
  belongs_to :resume
  has_many :industry, through: :industryexperience
  has_many :industryexperience, dependent: :destroy
  validates :location, presence: true
  validates :titlejob, presence: true
  validates :datestart, presence: true
  validates :employer, presence: true
  validates :description, presence: true

end
