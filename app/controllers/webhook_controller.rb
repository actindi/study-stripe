# frozen_string_literal: true

class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  WEBHOOK_ENDPOINT_SECRET = ENV['STRIPE_WEBHOOK_ENDPOINT_SECRET']

  def endpoint
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = Stripe::Webhook.construct_event(
      request.body.string,
      sig_header,
      WEBHOOK_ENDPOINT_SECRET
    )
    broadcast(event)
    head 200
  rescue JSON::ParserError => e
    # Invalid payload
    puts e
    head 400
  rescue Stripe::SignatureVerificationError => e
    # Invalid signature
    puts e
    head 400
  end

  def show; end

  private

  def broadcast(event)
    ActionCable.server.broadcast(WebhookChannel::STREAM, event: event)
  end
end
