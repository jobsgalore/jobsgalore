module PaymentsHelper
  def paypal_url(params = {})
    values = {
        cmd: '_xclick',
        charset: 'utf-8',
        business: 'accounting@jobsgalore.eu',
        return: params[:return_url],
        cancel_return: params[:cancel_url] || cancel_url_url,
        notify_url:  params[:notify_url] || payments_url,
        item_number: params[:item_number],
        item_name: params[:item_name],
        currency_code: params[:currency] || 'AUD',
        amount: params[:price]}
    domain = ENV["TEST"].nil? ? 'paypal' : 'sandbox.paypal'
    "https://www.#{domain}.com/cgi-bin/webscr?#{values.to_query}"
  end
end