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
  end
end
