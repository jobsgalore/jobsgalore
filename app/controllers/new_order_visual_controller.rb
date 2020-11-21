class NewOrderVisualController < ApplicationController

  def new
    begin
      @order = NewOrderVisual.new(
        type: params[:type],
        id:  params[:id]   ,
        ip: request.remote_ip
      )
    rescue
      puts "#{$!}"
      redirect_to root_path
    end
  end

  def create
    @order_service = SaveOrder.call(params: order_params, ip: request.remote_ip)
    respond_to do |format|
      if @order_service.success? #TODO Отправляем на paypal
        format.html do
          redirect_to(
            PayPal.new(
                return_url: @order_service.object.object.url,
                cancel_return: @order_service.object.object.url,
                notify_url: payments_url,
                item_number:@order_service.object.id_for_paypal,
                item_name: @order_service.object.product.name,
                currency_code: @order_service.object.current,
                amount: @order_service.object.price
            ).url
          )
          #     paypal_url({
          #       return_url: "",
          #       cancel_url: "path_for_object(@order_service.object)",
          #       item_number:@order_service.object.id_for_paypal,
          #       item_name: @order_service.object.product.name,
          #       price: @order_service.object.price,
          #       currency_code: @order_service.object.current
          # }))
        end
      else
        @order = @order_service.object
        format.html { render :new}
      end
    end

  end

  private

  def order_params
    params.require(:new_order_visual).permit(:id, :type, :product)
  end


end