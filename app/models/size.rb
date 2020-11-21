class Size < ApplicationRecord
  has_many :company, dependent: :destroy
end
