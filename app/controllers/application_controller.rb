# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  include Localize
  include Deviseable
  include CurrentInfo
  include Turbolinks
  include UserNotifications

  protect_from_forgery prepend: true
  fragment_cache_key { user_locale }

  # Addition contents for etag
  etag { current_user.try(:id) }
  etag { unread_notify_count }
  etag { flash }
  etag { Setting.navbar_html }
  etag { Setting.footer_html }
  etag { Rails.env.development? ? Time.now : Date.current }

  rescue_from ActiveRecord::RecordNotFound do |exception|
    respond_to do |format|
      format.json { head :not_found }
      format.html { render "/errors/404", status: :not_found }
    end
  end

  before_action do
    # always set user_id into cookie, to make sure ActionCable connection is current user.
    cookies.signed[:user_id] = current_user.try(:id)
    current_user&.touch_last_online_ts

    # hit unread_notify_count
    unread_notify_count
  end

  before_action :set_active_menu
  def set_active_menu
    @current = case controller_name
    when "pages"
      ["/wiki"]
    else
      ["/#{controller_name}"]
    end
  end

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    fname = %w[404 403 422 500].include?(status) ? status : "unknown"

    respond_to do |format|
      format.html { render template: "/errors/#{fname}", handler: [:erb], status: status, layout: "application" }
      format.all { render body: nil, status: status }
    end
  end

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to main_app.root_path, alert: t("common.access_denied")
  end

  def prefetch?
    request.headers["Purpose"] == "prefetch"
  end

  # Require Setting enabled module, else will render 404 page.
  def self.require_module_enabled!(name)
    before_action do
      unless Setting.has_module?(name)
        render_404
      end
    end
  end

  # 企业微信自动登录
  before_action :wxwork_auto_login
  def wxwork_auto_login
    if current_user.blank? && /MicroMessenger/i.match?(request.user_agent) && /wxwork/i.match?(request.user_agent)
      wechat_oauth2 do |user_name|
        return redirect_to new_user_session_path if user_name.blank?

        user = User.find_by_login(user_name)
        return redirect_to new_user_session_path if user.blank?

        sign_in :user, user
      end
    end
  end
end
