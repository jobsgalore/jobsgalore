# frozen_string_literal: true

module Services
  URGENT = OpenStruct.new name: 'Urgent', price: '15.00', price_integer: 15
  TOP = OpenStruct.new name: 'Ad Top', price: '20.00'
  HIGHLIGHT = OpenStruct.new name: 'Highlight', price: '10.00', price_integer: 10

  #TODO не используется. Удалить в будующем
  MAILING_TO_SEEKER = OpenStruct.new(
    name: 'letter to seekers',
    min_price: '5.00',
    one_email_price: '0.20',
    min_price_int: 5,
    one_email_price_float: 0.2
  )
end
