class Responded < ApplicationRecord
  belongs_to :doc, polymorphic: true
  belongs_to :client
end
