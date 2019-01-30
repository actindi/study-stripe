class RefundsController < ApplicationController

  def new
    charge_id = params[:charge_id]
    @charge = Stripe::Charge.retrieve(charge_id)

  end

  def create
    charge_id = params[:charge_id]
    @refund = Stripe::Refund.create(
      charge: charge_id
    )
  end
end
