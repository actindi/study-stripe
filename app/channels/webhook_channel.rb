# frozen_string_literal: true

#
# ActionCable channel for Webhook
#
class WebhookChannel < ApplicationCable::Channel
  STREAM = 'webhook'

  def subscribed
    stream_from STREAM
    ActionCable.server.broadcast(STREAM, 'Welcome!! Webhook channel')
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
