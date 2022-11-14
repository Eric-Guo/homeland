class GenerateUnicornifyAvatarJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find user_id
    return unless user.present?

    unicorn_avatar_path = Rails.root.join("public", "avatar")
    (0..9).each do |i|
      random_email = "#{user.email}#{i}"
      random_hash = Digest::MD5.hexdigest(random_email)
      stdout_str, stderr_str, status = Open3.capture3("unicornify -h #{random_hash} -s 128", chdir: unicorn_avatar_path)
      unless status.success?
        puts stdout_str
        puts stderr_str
      end
    end
  end
end
