class CustomersController < ApplicationController

  def index

    @customers = Stripe::Customer.list(limit: 10)

  end

  def show
    customer_id = params[:id]
    @customer = Stripe::Customer.retrieve(customer_id)
  end
end
