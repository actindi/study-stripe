class ChargesController < ApplicationController

  def index
    @charges = Stripe::Charge.list(limit: 10)
  end

  def new
  end

  def create
    # Amount in JPY
    @amount = 500

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source => params[:stripeToken],
    )

    charge = Stripe::Charge.create(
      :customer => customer.id,
      :amount => @amount,
      :description => 'Rails Stripe ご利用料金',
      :currency => 'jpy',
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
