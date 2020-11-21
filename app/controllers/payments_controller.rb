class PaymentsController < ApplicationController
  #before_action :set_client, only: [:show, :edit,:update, :destroy]
  #before_action :authenticate_client!
  protect_from_forgery except: [:create]
  load_and_authorize_resource only:[:index, :show]

  def bill
    @payment = Bill.call(params:payment_params)
    unless @payment.success?
      redirect_to render_404
    end
  end

  def cancel_url
  end


  def index
    @payment = Payment.all
  end

  def create
    @payment = CreatePayment.call(params:params)
    head :ok
  end

  private




  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_params
    params.require(:bill).permit(:id, :type, :option)
  end


end