# frozen_string_literal: true

class MailingDecorator < ApplicationDecorator
  delegate_all

  def payment_url
    if object.aasm_state == 'expect_the_payment'
      PayPal.new(
          return_url: h.show_mailings_url,
          cancel_return: h.show_mailings_url,
          notify_url: h.payments_url,
          item_number: "44#{object.id}",
          item_name: 'mailing',
          currency_code: object.cur,
          amount: object.price
      ).url
    end
  end
end
