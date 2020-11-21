class SaveOrder
  include Interactor
  def call
    context.object = NewOrderVisual.new(
            type: context.params[:type],
            id:   context.params[:id]   ,
            ip:   context.ip
    )
    context.object.set_product(context.params[:product])
    context.fail! unless context.object.save
  end
end