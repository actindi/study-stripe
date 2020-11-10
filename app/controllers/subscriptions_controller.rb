# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Stripe::Subscription.list(limit: 10)
  end

  def show
    subscription_id = params[:id]
    @subscription = Stripe::Subscription.retrieve(subscription_id)
  end

  def new
  end

  def create
  end


  def delete
  end
end
