class Product < ApplicationRecord
  has_many :orders


  def price_by_currency(currency)
    begin
      price[currency.to_s.upcase]['price']
    rescue
      Rails.logger.error('ERROR :Валюта не найдена')
    end
  end

  def self.find_by_type_and_option(type:, urgent:, highlight:)
    param = "#{type}_".capitalize
    if urgent and  !highlight
      param += "Urgent"
    elsif !urgent and  highlight
      param += "Highlight"
    elsif urgent and highlight
      param += "Urgent_And_Highlight"
    else
      raise "find_by_cur_type_and_option: Error in params"
    end
    self.find_by_name(param)
  end
end
