class Propert < ApplicationRecord

  def self.ads_turn_on?
    find_by_code('ads')&.value == '1'
  end

end

