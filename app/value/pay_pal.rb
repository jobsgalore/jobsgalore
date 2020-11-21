class PayPal
  CMD = '_xclick'
  CHARSET = 'utf-8'
  BUSINESS  = 'accounting@jobsgalore.eu'

  attr_accessor :domain, :return, :cancel_return, :notify_url, :item_number, :item_name, :currency_code , :amount
  def initialize(return_url:,cancel_return:,notify_url:,item_number:, item_name:, currency_code:'AUD' ,amount: )
    @domain = ENV["TEST"].nil? ? 'paypal' : 'sandbox.paypal'
    @return = return_url
    @cancel_return = cancel_return
    @notify_url = notify_url
    @item_number = item_number
    @item_name = item_name
    @currency_code = currency_code
    @amount = amount
  end


  def url
    values = {
        cmd: CMD,
        charset: CHARSET,
        business: BUSINESS,
        return: @return,
        cancel_return: @cancel_return,
        notify_url:  @notify_url,
        item_number: @item_number,
        item_name: @item_name,
        currency_code: @currency_code,
        amount: @amount
    }
    "https://www.#{@domain}.com/cgi-bin/webscr?#{values.to_query}"
  end
end