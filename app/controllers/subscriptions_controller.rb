# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Stripe::Subscription.list(
      limit: 10,
      status: 'all', # 指定しないと active な Subscription だけ取得する
      expand: ['data.customer']
    )
  end

  def show
    subscription_id = params[:id]
    @subscription = Stripe::Subscription.retrieve({ id: subscription_id, expand: %w[customer] })
  end

  def new
    @taxs = Stripe::TaxRate.list(limit: 10)
    @coupons = Stripe::Coupon.list(limit: 10)
    prices = Stripe::Price.list(
      limit: 10,
      active: true,
      expand: ['data.product']
    )
    @products = {}
    prices.each do |price|
      next unless price.product.active

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
      { customer: customer,
        default_payment_method: customer.default_source, # 支払いに使うカードを指定する
        items: [
          { price: price_id }
        ],
        default_tax_rates: [
          params[:tax]
        ],
        coupon: params[:coupon] },
      idempotency_key: Digest::MD5.hexdigest("#{customer.id}_#{Time.current.to_i}_#{params[:authenticity_token]}")
    )
    redirect_to subscriptions_path
  rescue => e
    redirect_to new_subscription_path, alert: "ERROR: #{e.message}"
  end

  def destroy
    subscription_id = params[:id]
    Stripe::Subscription.delete(subscription_id)

    redirect_to subscriptions_path, notice: "#{subscription_id}をキャンセルしました"
  end
end
