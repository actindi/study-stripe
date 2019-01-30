class RefundsController < ApplicationController

  def new
    charge_id = params[:charge_id]
    @charge = Stripe::Charge.retrieve(charge_id)

  end

  def create
    charge_id = params[:charge_id]
    refund_amount = params[:refund_amount]
    @refund = Stripe::Refund.create(
      charge: charge_id,
      amount: refund_amount
    )
  rescue => e
    puts e.class.name
    puts e.to_s
    puts e.message
    puts e.backtrace
    flash[:error] = e.to_s
    redirect_to new_refund_path(charge_id: charge_id)
  end
end
