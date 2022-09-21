# frozen_string_literal: true

# Auto generate with notifications gem.
class Notification < ActiveRecord::Base
  include Notifications::Model

  after_create :realtime_push_to_client
  after_update :realtime_push_to_client

  def realtime_push_to_client
    if user
      Notification.realtime_push_to_client(user)
      PushJob.perform_later(user_id, apns_note)
      NotifyWxworkJob.perform_later(user_id, wxwork_message)
    end
  end

  def self.realtime_push_to_client(user)
    message = {count: Notification.unread_count(user)}
    ActionCable.server.broadcast("notifications_count/#{user.id}", message)
  end

  def self.unread_count(user)
    where(user: user).unread.count
  end

  def apns_note
    @note ||= {alert: notify_title, badge: Notification.unread_count(user)}
  end

  def notify_title
    return "" if actor.blank?
    if notify_type == "topic"
      I18n.t("notifications.created_topic", actor: anonymous ? I18n.t("common.unknow_user") : actor.name, target: target.title)
    elsif notify_type == "topic_reply"
      I18n.t("notifications.created_reply", actor: anonymous ? I18n.t("common.unknow_user") : actor.name, target: second_target.title)
    elsif notify_type == "follow"
      I18n.t("notifications.followed_you", actor: actor.name)
    elsif notify_type == "mention"
      I18n.t("notifications.mentioned_you", actor: anonymous ? I18n.t("common.unknow_user") : actor.name)
    elsif notify_type == "node_changed"
      I18n.t("notifications.node_changed", node: second_target.name)
    else
      ""
    end
  end

  def anonymous
    return true if actor.blank?
    case notify_type
    when 'topic', 'topic_reply', 'mention', 'node_changed'
      target&.anonymous
    else
      false
    end
  end

  def wxwork_message
    case notify_type
    when "topic"
      "#{notify_title}\n<a href=\"#{Rails.application.routes.url_helpers.topic_url(target)}\">查看详情</a>"
    when "topic_reply"
      "#{notify_title}\n<a href=\"#{Rails.application.routes.url_helpers.topic_url(second_target)}\">查看详情</a>"
    else
      "#{notify_title}\n<a href=\"#{Rails.application.routes.url_helpers.root_url}\">查看详情</a>"
    end
  end

  def self.notify_follow(user_id, follower_id)
    opts = {
      notify_type: "follow",
      user_id: user_id,
      actor_id: follower_id
    }
    return if Notification.where(opts).count > 0
    Notification.create opts
  end
end
