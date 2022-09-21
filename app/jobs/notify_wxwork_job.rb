# frozen_string_literal: true

class NotifyWxworkJob < ApplicationJob
  queue_as :notifications

  def perform(user_id, text)
    Wechat.api.message_send(user_id, text)
  end
end
