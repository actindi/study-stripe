# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Stripe::Subscription.list(limit: 10, expand: ['data.customer'])
  end

  def show
    subscription_id = params[:id]
    @subscription = Stripe::Subscription.retrieve({ id: subscription_id, expand: %w[customer] })
  end

  def new
    prices = Stripe::Price.list(
      limit: 10,
      active: true,
      expand: ['data.product']
    )
    @products = {}
    prices.each do |price|
      if @products[price.product].blank?
        @products[price.product] = [price]
      else
        @products[price.product].push(price)
      end
    end
  end

  def create
    price_id = params[:price]

    if price_id.blank?
      redirect_to new_subscription_path, alert: '申し込み商品を選択してください'
      return
    end
    stripe_token = params[:stripeToken]

    customer = Stripe::Customer.create(
      source: stripe_token
    )

    Stripe::Subscription.create(
      customer: customer,
      items: [
        { price: price_id }
      ]
    )
    redirect_to subscriptions_path
  end

  def destroy
  end
end
