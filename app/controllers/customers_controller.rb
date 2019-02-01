class CustomersController < ApplicationController

  def index
    @customers = Stripe::Customer.list(limit: 10)
  end

  def show
    customer_id = params[:id]
    @customer = Stripe::Customer.retrieve(customer_id)
  end

  def add_card
    customer_id = params[:customer_id]
    stripeToken = params[:stripeToken]
    customer = Stripe::Customer.retrieve(customer_id)
    customer.sources.create(source: stripeToken)

    redirect_to customer_path(customer_id)
  end

  def remove_card
    customer_id = params[:customer_id]
    card_id = params[:card_id]

    customer = Stripe::Customer.retrieve(customer_id)
    customer.sources.retrieve(card_id).delete

    redirect_to customer_path(customer_id)
  end
end
